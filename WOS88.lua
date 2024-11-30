-- Simulation specific parameters
Running = true --don't touch or else the VM will never start!
timestep = 0
verbose = false -- verbose dumps the registers every iteration
flagverbose = false -- verbose dumps the flags every iteration
ramVerbose = false -- verbose dumps the ram every iteration <Host CPU will suffer.>

RAM = {} --RAM array. This will be modified later.

Registers = {--Moving forward, A = 1, B = 2, C = 3, D = 4, E = 5, F = 6, MAR = 7, PC = 8, SP = 9, IR = 10.
[0] = 0, -- Special Zero Register. keeps nils from popping up
[1] = 0,	--A
[2] = 0,	--B
[3] = 0,	--C
[4] = 0,	--D
[5] = 0,	--E
[6] = 0,	--F
[7] = 0,	--MAR
[8] = 0,	--PC
[9] = 0, 	--SP
[10] = 0	--IR
}

IRlookup = {
[0] = "NOP",
[0] = "ADD",
[0] = "SUB",
[0] = "MUL",
[0] = "DIV",
[0] = "INC",
[0] = "DEC",
[0] = "MOV",
[0] = "MPT",
[0] = "LOD",
[0] = "STO",
[0] = "JMP",
[0] = "JF",
[0] = "JNF",
[0] = "JSR",
[0] = "RTS",
[0] = "USO",
[0] = "USO",
[0] = "MIM",
[0] = "AND",
[0] = "OR",
[0] = "XOR",
[0] = "NOT",
[0] = "SHL",
[0] = "SHR",
[0] = "YIR",
[0] = "HLI",
[0] = "RTI",
[0] = "PSH",
[0] = "POP",
[0] = "HLT"

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
[1] = false,	--ZF
[2] = false,	--OF
[3] = false,	--EF
[4] = false,	--NF
[4] = true,		--1
[6] = false		--IF
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
	io.write("IR:",Registers[10],"\n")
	io.write("\n")
end

function PostOpChecks(target, source)

  if Registers[target] == 0 then -- check for zero flag
    Flags[1] = true
    print("Flag \"ZF\" True")
  else
    Flags[1] = false
  end

  if Registers[target] == Registers[source] then
    Flags[2] = true
    print("Flag \"EF\" True")
  else
    Flags[2] = false
  end

  -- Uncomment to handle overflow
  -- if tonumber(Registers[target]) >= 65535 then
  --   Registers[target] = Registers[target] % 65536
  --   Flags[3] = true
  --   print("Flag \"OF\" True")
  -- else
  --   Flags[3] = false
  -- end

  if Registers[target] ~= nil and Registers[target] < 0 then
    Flags[4] = true
    print("Flag \"NF\" True")
  else
    Flags[4] = false
  end
end
    

-- Opcode if-statement block
function Execute(opcode, source, target)
	--print(opcode, source, target) --TEMP
    if opcode == 0 then --NOP
    --print("NOP")
    elseif opcode == 1 then --ADD
    print("ADD",Registers[source],Registers[target])
    Registers[target] = Registers[source] + Registers[target]
    elseif opcode == 2 then --SUB
    print("SUB",Registers[source],Registers[target])
    Registers[target] = Registers[source] - Registers[target]
    elseif opcode == 3 then --MUL
    print("MUL",Registers[source],Registers[target])
    Registers[target] = Registers[source] * Registers[target]
	elseif opcode == 4 then --DIV
	print("DIV",Registers[source],Registers[target])
    Registers[target] = Registers[source] / Registers[target]
	elseif opcode == 5 then --INC
	print("INC",Registers[source],Registers[target])
    Registers[target] = Registers[target] + 1
	elseif opcode == 6 then --DEC
	print("DEC",Registers[source],Registers[target])
    Registers[target] = Registers[target] - 1
	elseif opcode == 7 then --MOV
	print("MOV",Registers[source],Registers[target])
	Registers[target] = Registers[source]
	elseif opcode == 8 then --MPT
	Registers[7] = source
	print("MPT",source,Registers[7])
	elseif opcode == 9 then --LOD
	Registers[target] = RAM[Registers[7]]
	elseif opcode == 10 then --STO
	RAM[Registers[7]] = Registers[target]
	elseif opcode == 11 then --JMP
	print("JMP",Registers[8],target)
	Registers[8] = target
	elseif opcode == 12 then --JF
	print("JF",Registers[source],target)
	if Flags[source] == true then
		Registers[8] = target
		end
	elseif opcode == 13 then --JNF
	print("JNF",Registers[source],Registers[target])
	if Flags[source] == false then
		Registers[8] = target
		end
	elseif opcode == 14 then --JSR
	print("(EE) Unfinished Opcode:", opcode)
	elseif opcode == 15 then --RTS
	print("(EE) Unfinished Opcode:", opcode)
	elseif opcode == 16 then --USO
	print("(EE) Removed Opcode:", opcode)
	elseif opcode == 17 then --USO
	print("(EE) Removed Opcode:", opcode)
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
	Registers[target] = Registers[source]
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
		Registers[10] = opcode
		source = RAM[Registers[8]+2]
		target = RAM[Registers[8]+3]
		Execute(opcode, source, target)
		Registers[8] = Registers[8] + 3
		timestep = timestep + 1
		if timestep >= 100 then Running = false print("(EE) Eval Runaway Prevention") end --Evaluation Runaway prevention
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
