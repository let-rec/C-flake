#include <stdio.h>
#include <unistd.h>


static void sysrq_handle_crash(int key)
{
    char *killer = NULL;

    panic_on_oops = 0;
    wmb();
    *killer = 1;
}
int main()
{
    sysrq_handle_crash(0);
    return 0;
}
