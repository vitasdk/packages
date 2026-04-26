const fs = require("fs");
const path = require("path");

const args = process.argv.slice(2);
const testFolder = '.';

const SLOW_PACKAGES = ['icu4c', 'ffmpeg']; // Puedes añadir más aquí

const dependant = new Map();
let directories = fs.readdirSync(testFolder).filter(file => fs.lstatSync(file).isDirectory());
directories = directories.filter(directory => fs.readdirSync(directory).includes("VITABUILD"));

directories.forEach(directory => {
    const content = fs.readFileSync(path.join(directory, "VITABUILD")).toString();
    const match = content.match(/^(?:make)?depends=(.*)/m);
    if (match) {
        const deps = match[1].replace(/[()'"']/g, "").trim().split(/\s+/).filter(Boolean);
        if (deps.length > 0) dependant.set(directory, deps);
    }
});

// Calculate Depth (Tier)
const depth = new Map();
function getDepth(pkg) {
    if (depth.has(pkg)) return depth.get(pkg);
    const deps = dependant.get(pkg) || [];
    if (deps.length === 0) {
        depth.set(pkg, 0);
        return 0;
    }
    let maxDepDepth = 0;
    deps.forEach(dep => {
        maxDepDepth = Math.max(maxDepDepth, getDepth(dep));
    });
    depth.set(pkg, maxDepDepth + 1);
    return maxDepDepth + 1;
}

let maxD = 0;
directories.forEach(pkg => { maxD = Math.max(maxD, getDepth(pkg)); });

// Determine if a package is on the "Slow Track" (itself is slow, or depends on a slow package)
const isSlowTrack = new Map();
function checkSlow(pkg) {
    if (isSlowTrack.has(pkg)) return isSlowTrack.get(pkg);
    if (SLOW_PACKAGES.includes(pkg)) {
        isSlowTrack.set(pkg, true);
        return true;
    }
    const deps = dependant.get(pkg) || [];
    for (let dep of deps) {
        if (checkSlow(dep)) {
            isSlowTrack.set(pkg, true);
            return true;
        }
    }
    isSlowTrack.set(pkg, false);
    return false;
}

directories.forEach(pkg => checkSlow(pkg));

// Distribute packages into Tiers and Tracks
const tiersMain = [];
const tiersSlow = [];
for (let i = 0; i <= maxD; i++) {
    tiersMain.push([]);
    tiersSlow.push([]);
}

directories.forEach(pkg => {
    const d = getDepth(pkg);
    if (isSlowTrack.get(pkg)) {
        tiersSlow[d].push(pkg);
    } else {
        tiersMain[d].push(pkg);
    }
});

// To prevent GitHub Actions Matrix errors when an array is empty, we add a dummy element
for (let i = 0; i <= maxD; i++) {
    if (tiersMain[i].length === 0) tiersMain[i].push("__dummy__");
    if (tiersSlow[i].length === 0) tiersSlow[i].push("__dummy__");
}

const output = {
    max_tier: maxD
};

for (let i = 0; i <= maxD; i++) {
    output[`tier${i}_main`] = tiersMain[i];
    output[`tier${i}_slow`] = tiersSlow[i];
}

if (args[0] !== 'deps') {
    console.log(JSON.stringify(output));
}


// Add CLI argument handling for 'deps'
if (args[0] === 'deps' && args[1]) {

    const pkg = args[1];
    
    const resolveDependency = (name, map) => {
        const deps = map.get(name);
        if (!deps) return [];
        const ret = [];
        deps.forEach((dep) => {
            ret.push(...resolveDependency(dep, map));
            ret.push(dep);
        });
        return ret;
    }

    let deps = resolveDependency(pkg, dependant);
    // Remove duplicates
    deps = [...new Set(deps)];
    
    // HACK: temporary fix openssl & openssl-1.1.1 confliction
    if (deps.includes('openssl') && deps.includes('openssl-1.1.1')) {
        deps = deps.filter((x) => x !== 'openssl');
    }

    if (deps.length > 0) {
        console.log(`@(${deps.join('|')})`);
    } else {
        console.log(`@()`);
    }
    process.exit(0);
}
