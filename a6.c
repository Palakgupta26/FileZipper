#include<stdio.h>
int main(){
	int n;
	printf("Enter the limit for the Array: ");
	scanf("%d",&n);
	int a[n];
	printf("Enter the numbers to be stored in the Array: ");
	for(int i=0;i<n;i++)
	{
		scanf("%d",&a[i]);
	}
	
	for(int i=0;i<n;i++){
		int count=1;
		for(int j=i+1;j<n;j++){
			if(a[i]==a[j]){
				a[j]=0;
				count++;
			}
		}
		if(count>1) a[i]=0;
	}
	printf("The dublicate elements are: ");
	for(int i=0;i<n;i++){
		if(a[i]!=0){
			printf("%d ",a[i]);
		}
	}
	printf("\n");
	return 0;
}