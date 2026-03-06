1. Proiectul MIPS cu Pipeline
Acest document oferă o descriere detaliată a proiectului MIPS cu pipeline pe 32 de biți, inclusiv componentele folosite, funcționalitatea acestora, instrucțiunile implementate și semnalele de control.

2. Componente folosite și funcționalitatea acestora
2.1 Generator de Monopuls Sincron (MPG.vhd)
•	Descriere: Generează un impuls sincron la o apăsare de buton.
•	Funcționalitate: Utilizează un numărător și 3 bistabile D Flip-Flop pentru a produce un impuls de o singură dată când un buton este apăsat.
2.2 Afișaj pe 7 segmente (SSD.vhd)
•	Descriere: Afișează cifrele pe un display de 7 segmente.
•	Funcționalitate: Folosește 7 LED-uri active (catozi) pentru a afișa cifrele. Catozii sunt comuni tuturor afișoarelor, iar afișajul este realizat prin activarea alternativă a diferitelor segmente.
2.3 Unitatea de extragere a instrucțiunilor (IFetch.vhd)
•	Descriere: Extrage instrucțiunile din memoria de instrucțiuni.
•	Funcționalitate: Primește adresele de salt și pune la dispoziție adresa următoare (PC+4) și conținutul instrucțiunii curente. Include o memorie ROM cu instrucțiuni predefinite pentru testare.
2.4 Unitatea de decodificare a instrucțiunilor (ID.vhd)
•	Descriere: Decodează instrucțiunile pentru a putea fi executate.
•	Funcționalitate: Primește instrucțiunea curentă și valoarea WD, care se scrie în RF. Pune la ieșire operanzii RD1, RD2, imediatul extins Ext_Imm, câmpurile function și sa. Include un registru de Registrare (RF) cu scriere sincronă.
2.5 Unitatea de control (UC.vhd)
•	Descriere: Generează semnalele de control pentru unitățile din calea de date.
•	Funcționalitate: Determină funcționalitatea unităților în funcție de tipul de instrucțiune. Generează semnale precum RegDst, ExtOp, ALUSrc, Branch, Jump, ALUOp, MemWrite, MemtoReg și RegWrite.
2.6 Unitatea de execuție (EX.vhd)
•	Descriere: Realizează operațiile aritmetice și logice necesare instrucțiunii.
•	Funcționalitate: Primește registrele RD1 și RD2, imediatul extins Ext_imm și adresa de instrucțiune următoare PC+4. Pune la dispoziție rezultatul ALU, semnalul de validare Zero și adresa de salt condiționat.
2.7 Unitatea de memorie (MEM.vhd)
•	Descriere: Stocare a datelor.
•	Funcționalitate: Scrierea în memorie este sincronă pe frontul de ceas ascendent, iar citirea este asincronă. Include o memorie RAM cu valori predefinite pentru testare.
2.8 Arhitectura completă a procesorului 
•	Descriere: Asamblează întregul procesor folosind componentele enumerate anterior.
•	Funcționalitate: Integrează toate componentele pentru a forma un procesor funcțional. Implementează registri pentru stocarea stadiilor pipeline-ului și include un multiplexor pentru alegerea surselor de date pentru afișaj.
3. Registri pentru stocarea stadiilor pipeline-ului
3.1 PC (Program Counter)
•	Descriere: Registru special care conține adresa instrucțiunii următoare care va fi preluată.
•	Funcționalitate: Actualizează adresa următoare în funcție de starea de execuție (PC+4, salt condiționat sau incondiționat).
3.2 IF/ID (Instruction Fetch/Instruction Decode)
•	Descriere: Registru de transfer care stochează instrucțiunea preluată din memoria de instrucțiuni și alte informații relevante pentru decodare.
•	Funcționalitate: Păstrează valoarea curentă a PC și instrucțiunea citită pentru a fi folosită în etapa de decodare.
3.3 ID/EX (Instruction Decode/Execution)
•	Descriere: Registru de transfer care conține datele decodate ale instrucțiunii și semnalele de control necesare pentru etapa de execuție.
•	Funcționalitate: Păstrează operanzii RD1, RD2, imediatul extins, câmpurile function și sa, precum și semnalele de control pentru unitatea de execuție.
3.4 EX/MEM (Execution/Memory Access)
•	Descriere: Registru de transfer care stochează rezultatele etapei de execuție și semnalele de control asociate accesului la memorie.
•	Funcționalitate: Păstrează rezultatul ALU, semnalul Zero, adresa de salt condiționat și semnalele de control pentru accesul la memorie.
3.5 MEM/WB (Memory Access/Write Back)
•	Descriere: Registru de transfer care conține datele și semnalele de control pentru accesul la memorie și operațiile de scriere înapoi în registrele de destinație.
•	Funcționalitate: Păstrează datele citite din memorie sau rezultatele ALU pentru a le scrie înapoi în registrele de destinație.
•	Toate componentele enumerate sunt funcționale, fără a prezenta probleme de funcționare. Acestea au fost testate integral pe plăcuță.
Pe parcursul dezvoltării proiectului au apărut diverse probleme de proiectare, cum ar fi atribuirea incorectă a unor valori, rezolvarea greșită a hazardurilor, calcularea greșită a adresei de jump si a offset-ului la BEQ sau erori în implementarea programului MIPS32. Aceste probleme au fost identificate și remediate treptat. Programul din IFetch nu se execută complet corect.
