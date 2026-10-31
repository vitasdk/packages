#include <stdint.h>

#include <mz.h>
#include <mz_crypt.h>
#include <unzip.h>

int main(void)
{
    /* The HMAC and the AES zip support are where minizip calls into
     * OpenSSL; the compatibility unzip API pulls in the reader. */
    void *hmac = mz_crypt_hmac_create();
    if (hmac == NULL)
        return 1;

    int32_t err = mz_crypt_hmac_init(hmac, "key", 3);
    mz_crypt_hmac_delete(&hmac);
    if (err != MZ_OK)
        return 1;

    unzFile file = unzOpen64("missing.zip");
    if (file != NULL)
        unzClose(file);
    return 0;
}
