#include <curl/curl.h>
#include <openssl/opensslconf.h>

#ifndef OPENSSL_NO_UI_CONSOLE
#error "The Vita OpenSSL headers must publish the disabled console UI"
#endif

int main(void)
{
    CURLcode result = curl_global_init(CURL_GLOBAL_DEFAULT);
    if (result != CURLE_OK)
        return 1;

    CURL *curl = curl_easy_init();
    if (curl == NULL) {
        curl_global_cleanup();
        return 1;
    }

    result = curl_easy_setopt(curl, CURLOPT_URL, "https://example.invalid/");
    if (result == CURLE_OK)
        result = curl_easy_perform(curl);

    curl_easy_cleanup(curl);
    curl_global_cleanup();
    return result != CURLE_OK;
}
