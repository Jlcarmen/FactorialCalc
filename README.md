https://drive.google.com/drive/folders/15Hsxs9aEN2G7lAbzbnsrTOOLcQMSdTxe

# **Factorial Calculator in Assembly (NASM)**  

This project is a simple **factorial calculator** written in **x86 Assembly (NASM)** that calculates the factorial of a given non-negative integer.  

## **How It Works**  
- The program prompts the user to **enter a non-negative integer**.  
- It then **calculates the factorial** using an **iterative approach**.  
- The result is **displayed on the screen**.  
- The user is given the option to **enter another number or exit** the program.  

## **Requirements**  
- **NASM** (Netwide Assembler)  
- **Linux with x86 architecture** (or an emulator like QEMU/VirtualBox)  

## **Installation & Usage**  

### **1. Clone the Repository**  
```bash
git clone https://github.com/Jlcarmen/FactorialCalc.git
cd FactorialCalc
```

### **2. Assemble and Link the Program**  
```bash
nasm -f elf32 factorial.asm -o factorial.o
ld -m elf_i386 factorial.o -o factorial
```

### **3. Run the Program**  
```bash
./factorial
```

## **Example Output**  
```
Enter a non-negative integer: 5
Factorial: 120
Do you want to enter another number? (y/n): n
Exiting program...
```

