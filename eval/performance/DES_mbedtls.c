/*
 * Description: This file is create for testing mbedtls(2.1.1)
 * DES encryption algorithm on 32-bit linux
*/

#include "mbedtls/des.h"
#include <stdio.h>
#include <stdlib.h>

//#define CADL_DEBUG

int main(int argc, char **argv)
{
	unsigned char key[8]       = {0x13, 0x34, 0x57, 0x79, 0x9b, 0xbc, 0xdf, 0xf1};
	unsigned char plaintext[8] = {0x00, 0x23, 0x45, 0x67, 0x89, 0xab, 0xcd, 0xef};
	//unsigned char key[8] = {0x00};
	//unsigned char plaintext[8] = {0x00};
	unsigned char ciphertext[8] = {0x00};
	mbedtls_des_context ctx;
	int times = 1;
	int sum = 0;
	int ret = 0;
	int i;
#ifdef CADL_DEBUG
	int j;
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
		mbedtls_des_init(&ctx);

		// encryption key initialization
		mbedtls_des_setkey_enc(&ctx, key);

		// encryption in EBC mode
		ret = mbedtls_des_crypt_ecb(&ctx, plaintext, ciphertext); 

		// add the final result byte to avoid compiler optimization
		sum += ciphertext[0];

		// clean ctx
		mbedtls_des_free(&ctx);

#ifdef CADL_DEBUG
		// for debug
		printf("times:0x%x\n", times);
		printf("plaintext:\n");
		for (j=0; j<8; j++)
		{
			printf("%02X ", plaintext[j]);
		}
		printf("\n");

		printf("key:\n");
		for (j=0; j<8; j++)
		{
			printf("%02X ", key[j]);
		}
		printf("\n");

		printf("cihpertext:\n");
		for (j=0; j<8; j++)
		{
			printf("%02X ", ciphertext[j]);
		}
		printf("\n");
#endif
	}

	// refer to sum to avoid compiler optimization
	printf("res: %x\n", sum);
	sum = sum;

	return 0;
}

