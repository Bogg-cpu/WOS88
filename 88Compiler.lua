--Assembler for the WOS88 VM, Developed by Bogg
--30 instructions of fun, 64k core max as default

kill = false --Kill command if the strict flag is enabled. This will terminate the compilation premature instead of allowing illegal instructions to pass compilation.
strict = false --Flag that will terminate the compilation when an error is encountered, and dump the incomplete file for debugging.

function compile(filename, preFileSpace, strictmode)
	timestart = os.clock()
	local file = io.open(filename, "r")
	
	if strictmode == "lazy" then
		strict = false
		else
		strict = true
	end
	
	if strict == false then
		print("(WW) Strict Mode is disabled. Programs will not be monitored for errors. Run at your own risk!")
	end
	
	if file == nil then
		print("(EE) File is empty or not found. Check your file path or contents and try again.")
		os.exit(1) --exit with an error code to prevent tainted states
	end
	
	local compiled = {} --initialize the compiled list for the next steps
	
	if preFileSpace == nil then --set stack space to the default if there is none specified
		preFileSpace = 255
		print("(WW) Prefile stack space was not defined. Defaulting to 255.") 
	end
	
	for i = 1, preFileSpace do --allocate stack space
		table.insert(compiled, 0)
	end
	
	print("(II) Pre-file-space allocated.")
	
	local opcodes = { --opcode list in their ASM -> machine code counterparts
		NOP = 0, ADD = 1, SUB = 2, MUL = 3, DIV = 4, INC = 5, DEC = 6, 
		MOV = 7, MPT = 8, LOD = 9, STO = 10, JMP = 11, JF = 12, JNF = 13,
		JSR = 14, RTS = 15, USO1 = 16, USO2 = 17, MIM = 18, AND = 19, OR = 20,
		XOR = 21, NOT = 22, SHL = 23, SHR = 24, YIR = 25, HLI = 26, RTI = 27, 
		PSH = 28, POP = 29, HLT = 30, REM = 31 -- Remark/Comment instruction. Ignored in the compiler.
	}
  
	-- Begin Assembly
	for line in file:lines() do
		-- Trim and split line to handle different cases
		local opcode, operand1, operand2 = line:match("(%S+)%s*(%S*)%s*(%S*)")
		opcode = opcode and opcode:upper() or ""
		
		if opcodes[opcode] then -- Valid opcode
			if opcode ~= "REM" then
				table.insert(compiled, opcodes[opcode])
				table.insert(compiled, tonumber(operand1) or 0) -- Convert operands to numbers
				table.insert(compiled, tonumber(operand2) or 0)
			end
		else  -- Invalid opcode handling
			if strict then
				kill = true
				table.insert(compiled, "INVALID >>>")
				table.insert(compiled, opcode)
				table.insert(compiled, operand1)
				table.insert(compiled, operand2)
				table.insert(compiled, "<<< INVALID")
			end
			print("(EE) Invalid instruction: ", opcode, operand1, operand2)
		end
		
		if kill then 
			file:close() -- Premature close of the file if strict flag issues a kill command
			return compiled
		end
	end
	file:close()
	return compiled
end

function export(compiled)
	local file = io.open("compiled.txt", "w")
	if file == nil then
		print("(EE) File not found?? Check your permissions and try again.")
		return
	end

	file:write("{")
	for i = 1, #compiled do
		file:write(compiled[i])
		if i ~= #compiled then
			file:write(",")
		end
	end
	file:write("}")
	
	file:close()
	if not kill then
		print("(II) Build complete.")
	else
		print("(EE) Build terminated due to an error.")
	end
	local timeend = os.clock()
	print("(II) Time taken: " .. timeend - timestart .. " seconds")
	print("(II) Time taken: " .. (timeend - timestart) * 1000000 .. " μs")
end

print("------COMPILE START------")
local compiled = compile("asm.txt", 255, "strict") -- Example: pre-file space of 255 zeroes
export(compiled)
if not kill then
	if true then
	print("\n----QUICKLAUNCH START----")
	os.execute("lua WOS88.lua")
	end
	os.exit(0)
else
	os.exit(1)
end
