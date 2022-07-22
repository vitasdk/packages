const testFolder = '.';
const fs = require('fs');
const path = require('path')

const dependant = new Map();

const args = process.argv.slice(2);

let isDependant = false;

switch (args[0]) {
    case 'dependant':
        isDependant = true;
        break;
    case 'non_dependant':
        break;
    default:
        return;
}

resolveDependency = (name, map) => {
    const dependencies = map.get(name);
    if (!dependencies) {
        return [];
    }

    dependencies.forEach((dependency) => {
        const deps = resolveDependency(dependency, map);
        if (deps.length > 0) {
            deps.forEach((dep) => {
                dependencies.push(dep);
            });
        }
    });

    return dependencies;

}


let directories = fs.readdirSync(testFolder).filter(file => fs.lstatSync(file).isDirectory());

directories = directories.filter(directory => {
    return fs.readdirSync(directory).filter(file => file == 'VITABUILD').length > 0;
});

directories.forEach(directory => {
    const content = fs.readFileSync(path.join(directory, "VITABUILD"));
    const lines = content.toString().split('\n');
    for (let i = 0; i < lines.length; i++) {
        const KV = lines[i].split("=");
        if (KV.length > 1 && (KV[0].trim() == 'depends' || KV[0].trim() == 'makedepends')) {

            const dependencies = KV[1].trim().replace("(", "").replace(")", "").replace(/\'||\)/g, "").split(' ');
            if (dependencies[0] != '') {
                dependant.set(directory, dependencies);
            }

            break;
        }
    }

})


dependant.forEach((value, key) => {
    resolveDependency(key, dependant);
})

const output = {
    non_dependant: [],
    dependant: []
};

directories.forEach(library => {
    const dependencies = dependant.get(library);
    if (dependencies) {
        let info = library;
        const deps = [];
        dependencies.forEach((dependency) => {
            if (dependant.get(dependency))
                deps.push(dependency);
        });
        deps.forEach(dependency => info = dependency + " " + info);
        output.dependant.push(info);
    } else {
        output.non_dependant.push(library);
    }
})

if(isDependant)
    console.log(JSON.stringify(output.dependant))
else
    console.log(JSON.stringify(output.non_dependant))

