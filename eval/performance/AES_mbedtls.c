/*
 * Description: This file is create for testing mbedtls(2.1.1)
 * AES128 encryption algorithm on 32-bit linux
*/

#include "mbedtls/aes.h"
#include <stdio.h>
#include <stdlib.h>

//#define CADL_DEBUG

int main(int argc, char **argv)
{
	unsigned char key[16] = {0x00};
	unsigned char plaintext[16] = {0x00};
	unsigned char ciphertext[16] = {0x00};
	unsigned char iv[16] = {0};
	mbedtls_aes_context ctx;
	int times = 1;
	int sum = 0;
	int ret = 0;
	int i;
#ifdef CADL_DEBUG
	int j,k;
#endif

	// repeate times
	times = atoi(argv[1]);

	// repeate encryption
	for (i=0; i<times; i++)
	{
		// initialize key and pt
		key[0]       = i & 0xff;
		key[1]       = (i>>8) & 0xff;
		key[2]       = (i>>16) & 0xff;
		key[3]       = (i>>24) & 0xff;
		plaintext[0] = i & 0xff;
		plaintext[1] = (i>>8) & 0xff;
		plaintext[2] = (i>>16) & 0xff;
		plaintext[3] = (i>>24) & 0xff;

		// initialize ctx
		mbedtls_aes_init(&ctx);

		// encryption key initialization
		mbedtls_aes_setkey_enc(&ctx, key, 128);

		// encryption in CBC mode
		ret = mbedtls_aes_crypt_ecb(&ctx, MBEDTLS_AES_ENCRYPT,
				                    plaintext, ciphertext); 

		// add the final result byte to avoid compiler optimization
		sum += ciphertext[0];

		// clean ctx
		mbedtls_aes_free(&ctx);

#ifdef CADL_DEBUG
		// for debug
		printf("times:0x%x\n", times);
		printf("plaintext:\n");
		for (j=0; j<4; j++)
		{
			for (k=0; k<4; k++)
			{
				printf("%02X ", plaintext[j*4+k]);
			}
			printf("\n");
		}

		printf("key:\n");
		for (j=0; j<16; j++)
		{
			printf("%02X ", key[j]);
		}
		printf("\n");

		printf("cihpertext:\n");
		for (j=0; j<4; j++)
		{
			for (k=0; k<4; k++)
			{
				printf("%02X ", ciphertext[j*4+k]);
			}
			printf("\n");
		}
#endif
	}

	// refer to sum to avoid compiler optimization
	printf("res: %x\n", sum);
	sum = sum;

	return 0;
}

