-- Simulation specific parameters
Running = true --don't touch or else the VM will never start!
timestep = 0
verbose = false -- verbose dumps the registers every iteration
flagverbose = false -- verbose dumps the flags every iteration
ramVerbose = false -- verbose dumps the ram every iteration <Host CPU will suffer.>

RAM = {} --RAM array. This will be modified later.

Registers = {--Moving forward, A = 1, B = 2, C = 3, D = 4, E = 5, F = 6, MAR = 7, PC = 8, SP = 9.
[1] = 0,	--A
[2] = 0,	--B
[3] = 0,	--C
[4] = 0,	--D
[5] = 0,	--E
[6] = 0,	--F
[7] = 0,	--MAR
[8] = 0,	--PC
[9] = 0 	--SP
}

ShadowRegisters = {--Moving forward, A = 1, B = 2, C = 3, D = 4, E = 5, F = 6, MAR = 7, PC = 8.
[1] = 0,	--A
[2] = 0,	--B
[3] = 0,	--C
[4] = 0,	--D
[5] = 0,	--E
[6] = 0,	--F
[7] = 0,	--MAR
[8] = 0 	--PC
}

Flags = {
ZF = false, --Zero Flag, raised when Target == 0
OF = false, --Overflow Flag, raised when Target overflows past 255
EF = false  --Equal Flag, raised when Target == Source after an operation
}

--Debug Funcs
function FullCoreDump()
	io.write("\n--------CORE DUMP--------\n")
	for i = 1, #RAM do
		io.write(RAM[i]," ")
		if RAM[i]<10 then
		io.write(" ")
		end
		if RAM[i]<100 then
		io.write(" ")
		end
		if RAM[i]<1000 then
		io.write(" ")
		end
		if RAM[i]<10000 then
		io.write(" ")
		end
		
		if (i+1) % 15 == 1 then
		io.write("\n")
		end
		io.flush()
		end
		print("\n")
end
function RegDump()
	io.write("\n------REGISTER DUMP------\n")
	io.write("A:",Registers[1],"\n")
	io.write("B:",Registers[2],"\n")
	io.write("C:",Registers[3],"\n")
	io.write("D:",Registers[4],"\n")
	io.write("E:",Registers[5],"\n")
	io.write("F:",Registers[6],"\n")
	io.write("MAR:",Registers[7],"\n")
	io.write("PC:",Registers[8],"\n")
	io.write("IC:",(Registers[8]/3)-84,"\n")
	io.write("SP:",Registers[9],"\n")
	io.write("\n")
end
function PostOpChecks(target,source)
  if Registers[target] == 0 then -- check for zero flag
    Flags.ZF = true
	print("Flag \"ZF\" True")
    else
    Flags.ZF = false
    end
  if Registers[target] == Registers[source] then
	Flags.EF = true
	print("Flag \"EF\" True")
	else
	Flags.EF = false
	end
  --if tonumber(Registers[target]) >= 65535 then -- check for overflow (and handle it)
    --Registers[target] = Registers[target] % 65536 -- modulo to emulate overflow
    --Flags.OF = true
    --print("Flag \"OF\" True")
    --else
    --Flags.OF = false
    --end
end
    

-- Opcode if-statement block
function Execute(opcode, source, target)
	--print(opcode, source, target) --TEMP
    if opcode == 0 then --NOP
    --print("NOP")
    elseif opcode == 1 then --ADD (Verified)
    Registers[target] = Registers[source] + Registers[target]
	print("ADD",Registers[source],Registers[target])
    elseif opcode == 2 then --SUB (Verified)
    Registers[target] = Registers[source] - Registers[target]
    elseif opcode == 3 then --MUL (Verified)
    Registers[target] = Registers[source] * Registers[target]
	elseif opcode == 4 then --DIV (Verified)
    Registers[target] = Registers[source] / Registers[target]
	elseif opcode == 5 then --INC (Verified)
    Registers[target] = Registers[target] + 1
	elseif opcode == 6 then --DEC (Verified)
    Registers[target] = Registers[target] - 1
	elseif opcode == 7 then --MOV (Verified)
	Registers[target] = Registers[source]
	elseif opcode == 8 then --MIM (Verified)
	Registers[7] = Registers[source]
	elseif opcode == 9 then --LOD
	Registers[target] = RAM[Registers[7]]
	elseif opcode == 10 then --STO
	RAM[Registers[7]] = Registers[target]
	elseif opcode == 11 then --JMP
	Registers[8] = Registers[target]
	elseif opcode == 12 then --JZ
	if Flags.ZF == true then
		Registers[8] = Registers[target]
		end
	elseif opcode == 13 then --JNZ
	if Flags.ZF == false then
		Registers[8] = Registers[target]
		end
		elseif opcode == 14 then --JO
	if Flags.OF == true then
		Registers[8] = Registers[target]
		end
	elseif opcode == 15 then --JNO
	if Flags.OF == false then
		Registers[8] = Registers[target]
		end
	elseif opcode == 16 then --JE
	if Flags.EF == true then
		Registers[8] = Registers[target]
		end
	elseif opcode == 17 then --JNE
	if Flags.EF == false then
		Registers[8] = Registers[target]
		end
	elseif opcode == 18 then --MIM
	Registers[target] = source
	elseif opcode == 19 then --AND
	Registers[target] = (Registers[source] & Registers[target])
	elseif opcode == 20 then --OR
	Registers[target] = (Registers[source] | Registers[target])
	elseif opcode == 21 then --XOR
	Registers[target] = (Registers[source] ~ Registers[target])
	elseif opcode == 22 then --NOT
	Registers[target] = (~Registers[target])
	elseif opcode == 23 then --SHL
	Registers[target] = (Registers[target] << Registers[source])
	elseif opcode == 24 then --SHR
	Registers[target] = (Registers[target] >> Registers[source])
	elseif opcode == 25 then --YIR
	--TBI
	elseif opcode == 26 then --HLI
	--TBI
	elseif opcode == 27 then --RTI
	--TBI
	elseif opcode == 28 then --PSH
	RAM[Registers[9]] = Registers[source]
	Registers[9] = Registers[9] + 1
	elseif opcode == 29 then --POP
	Registers[target] = RAM[Registers[9]]
	Registers[9] = Registers[9] - 1
	elseif opcode == 30 then --HLT
	--print("Halted")
	Running = false
	else do
	print("(EE) Unknown opcode:", opcode)
	end
	end
	PostOpChecks(target,source)
	--print("==", Registers[source], Registers[target])
	RegDump()
	for i = 0, 100000000 do end --TEMP
end

function loadRAM(filename)
	local file = io.open(filename, "r")
	if file == nil then
		print("(EE) Failed to open file. Check if the file exists and try again.")
		return nil
	end

	local content = file:read("*all") -- Read the entire file content
	file:close()

	-- Remove braces and split by commas
	content = content:match("{(.*)}") -- Capture contents inside the braces
	if not content then
		print("(EE) Invalid file format. Expected format: {value1,value2,...}")
		return nil
	end

	local RAM = {}
	for value in content:gmatch("([^,]+)") do
		table.insert(RAM, tonumber(value))
	end

	print("(II) RAM loaded successfully with " .. #RAM .. " entries.")
	return RAM
end

--Control Loop
function Run()
	while Running do
		--insert debug stuff
		opcode = RAM[Registers[8]+1]
		source = RAM[Registers[8]+2]
		target = RAM[Registers[8]+3]
		Execute(opcode, source, target)
		Registers[8] = Registers[8] + 3
		timestep = timestep + 1
		if timestep >= 100000 then Running = false print("(EE) Eval Runaway Prevention") end --Evaluation Runaway prevention
		end
end

RAM = loadRAM("compiled.txt")

Registers[8] = 255 --Skip the stack
Registers[9] = 1

timebefore = os.clock()
Run()
timeafter = os.clock()
FullCoreDump()
RegDump()
print("Time taken: " .. timeafter - timebefore .. " seconds")
print("Time taken: " .. (timeafter - timebefore)*1000 .. " ms")
print("Time taken: " .. (timeafter - timebefore)*1000000 .. " μs")
print("Timesteps to halt: ".. timestep .. " steps")
os.exit(0)
