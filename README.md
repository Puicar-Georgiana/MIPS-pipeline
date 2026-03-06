MIPS32 Pipeline Processor (VHDL)
Descriere proiect
Acest proiect implementează un procesor MIPS32 cu arhitectură pipeline pe 32 de biți, realizat în VHDL. Scopul proiectului este simularea și testarea unui procesor care execută instrucțiuni în paralel folosind tehnica instruction pipelining.
Procesorul este construit modular și include unități separate pentru:
•	extragerea instrucțiunilor
•	decodare
•	execuție
•	acces la memorie
•	scriere înapoi în registre
Proiectul a fost realizat și testat folosind Xilinx Vivado, iar componentele au fost verificate atât în simulare, cât și pe placă FPGA.

Arhitectura procesorului
Procesorul este organizat pe 5 stadii pipeline:
1.	IF – Instruction Fetch
2.	ID – Instruction Decode
3.	EX – Execute
4.	MEM – Memory Access
5.	WB – Write Back
Între aceste stadii există registre pipeline care stochează rezultatele intermediare.

Componente și funcționalitate
1. Generator de Monopuls Sincron (MPG.vhd)
Descriere
Generează un impuls sincron la apăsarea unui buton.
Funcționalitate
•	utilizează un numărător
•	folosește 3 bistabile D Flip-Flop
•	produce un singur impuls pentru fiecare apăsare de buton
Acest modul este utilizat pentru controlul execuției pe placa FPGA.

2. Afișaj pe 7 segmente (SSD.vhd)
Descriere
Permite afișarea valorilor numerice pe un display cu 7 segmente.
Funcționalitate
•	utilizează 7 LED-uri active
•	catozii sunt comuni pentru toate afișajele
•	afișarea se realizează prin multiplexarea segmentelor

3. Instruction Fetch Unit (IFetch.vhd)
Descriere
Responsabilă pentru extragerea instrucțiunilor din memoria de instrucțiuni.
Funcționalitate
•	calculează PC + 4
•	gestionează instrucțiuni de branch și jump
•	furnizează:
o	instrucțiunea curentă
o	adresa următoarei instrucțiuni
Include:
•	ROM cu instrucțiuni predefinite pentru testare.

4. Instruction Decode Unit (ID.vhd)
Descriere
Decodează instrucțiunile și pregătește datele pentru execuție.
Funcționalitate
Primește:
•	instrucțiunea curentă
•	datele de scriere în registre (WD)
Produce:
•	RD1
•	RD2
•	Ext_Imm (imediat extins)
•	câmpurile function
•	sa (shift amount)
Include:
•	Register File (RF) cu scriere sincronă.

5. Control Unit (UC.vhd)
Descriere
Generează semnalele de control pentru calea de date a procesorului.
Funcționalitate
Semnalele generate includ:
•	RegDst
•	ExtOp
•	ALUSrc
•	Branch
•	Jump
•	ALUOp
•	MemWrite
•	MemtoReg
•	RegWrite
Acestea determină modul de execuție al fiecărei instrucțiuni.

6. Execution Unit (EX.vhd)
Descriere
Realizează operațiile aritmetice și logice ale instrucțiunilor.
Funcționalitate
Primește:
•	RD1
•	RD2
•	Ext_Imm
•	PC + 4
Produce:
•	rezultatul ALU
•	semnalul Zero
•	adresa pentru branch

7. Memory Unit (MEM.vhd)
Descriere
Unitatea responsabilă pentru stocarea datelor.
Funcționalitate
•	scriere sincronă la frontul ascendent al ceasului
•	citire asincronă
Include:
•	RAM cu valori predefinite pentru testare.

8. Arhitectura completă a procesorului
Descriere
Integrează toate modulele într-un procesor pipeline complet.
Funcționalitate
•	conectează toate unitățile funcționale
•	implementează registre pipeline
•	include multiplexor pentru selectarea datelor afișate pe display

Registrele Pipeline
Pentru implementarea execuției pipeline sunt utilizate registre între stadii.
PC (Program Counter)
Descriere
Registru special care stochează adresa următoarei instrucțiuni.
Funcționalitate
Actualizează adresa în funcție de:
•	PC + 4
•	branch
•	jump

IF/ID Register
Descriere
Registru de transfer între stadiile Instruction Fetch și Instruction Decode.
Funcționalitate
Stochează:
•	instrucțiunea curentă
•	valoarea PC

ID/EX Register
Descriere
Registru între stadiile Decode și Execute.
Funcționalitate
Stochează:
•	RD1
•	RD2
•	Ext_Imm
•	function
•	sa
•	semnale de control pentru EX

EX/MEM Register
Descriere
Registru între stadiile Execute și Memory.
Funcționalitate
Stochează:
•	rezultatul ALU
•	semnalul Zero
•	adresa de branch
•	semnale de control pentru MEM

MEM/WB Register
Descriere
Registru între stadiile Memory și Write Back.
Funcționalitate
Stochează:
•	datele citite din memorie
•	rezultatul ALU
•	semnale pentru scrierea în registri

Testarea proiectului
Toate componentele au fost testate:
•	în Vivado Simulator
•	pe placa FPGA
În timpul dezvoltării au apărut probleme precum:
•	atribuirea incorectă a unor semnale
•	rezolvarea greșită a hazardurilor
•	calcularea incorectă a adreselor jump
•	calcularea incorectă a offset-ului pentru BEQ
•	erori în implementarea programului MIPS
Aceste probleme au fost identificate și corectate progresiv.
Programul din IFetch nu se execută complet corect în forma actuală.

Instrucțiuni MIPS32 implementate
Procesorul suportă un subset al instrucțiunilor MIPS32, incluzând:
R-Type
•	add
•	sub
•	and
•	or
•	sll
•	srl
I-Type
•	addi
•	lw
•	sw
•	beq
J-Type
•	jump

Schema procesorului Pipeline
Procesorul utilizează arhitectura pipeline clasică MIPS cu 5 stadii:
IF → ID → EX → MEM → WB
Fiecare stadiu execută simultan o parte diferită a instrucțiunii.

RTL Design
Proiectul este realizat la nivel RTL (Register Transfer Level) și include:
•	registre pipeline
•	unitate ALU
•	memorie de instrucțiuni
•	memorie de date
•	multiplexoare
•	unitate de control

Tehnologii utilizate
•	VHDL
•	MIPS32 Architecture
•	RTL Design
•	Xilinx Vivado
•	FPGA
