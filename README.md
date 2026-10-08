# microprocessor-verilog

A SystemVerilog re-implementation of my pipelined VHDL microprocessor (see the `Microprocessor-HDL` repository for the finished VHDL design). The aim is to rebuild the same architecture in SystemVerilog and move from hand-written testbenches towards a UVM-style verification environment.

> **Status: work in progress.** The ALU and ROM are written and the ALU testbench passes. The decoder, instruction queue, controller and top level have not been ported yet.

## Target design

The processor fetches a 32-bit instruction, decodes it into an opcode and three 5-bit register addresses, reads two operands from a 32 × 32-bit register store, executes them in the ALU and writes the result back, with forwarding to avoid read-before-write hazards.

Instruction format: `[31:26]` opcode, `[25:21]` A1, `[20:16]` A2, `[15:11]` A3, meaning `A1 <opcode> A2 → A3`.

## Progress

| Module | Status | Notes |
|--------|--------|-------|
| `alu` | Written, testbench passes | Synchronous, 32-bit, 6-bit opcode |
| `rom` | Written, needs fixes | Two registered read ports. See [known issues](#known-issues) |
| Decoder | Not started | |
| Instruction queue | Not started | |
| Controller / forwarding | Not started | |
| Top level | Not started | |
| UVM testbench | Scaffolding only | Does not compile yet |

## ALU

Operations are selected by a 6-bit opcode and registered on the rising clock edge.

| Operation | Opcode | Status |
|-----------|:------:|--------|
| `a + b` | `000100` | Implemented |
| `a − b` | `001000` | Implemented |
| `\|a\|` | `001011` | TODO |
| `−a` | `001010` | Implemented |
| `\|b\|` | `001110` | TODO |
| `−b` | `000110` | Implemented |
| `a or b` | `000111` | Implemented |
| `not a` | `001001` | Implemented |
| `not b` | `001111` | Implemented |
| `a and b` | `000010` | Implemented |
| `a xor b` | `000011` | Implemented |

### Testbench

`alu_tb.sv` drives three additions and prints them with `$monitor`:

| inputA | inputB | Result |
|-------:|-------:|-------:|
| 255 | 255 | 510 |
| 48879 | 51966 | 100845 |
| 57005 | 43605 | 100610 |

The output appears one clock cycle after the inputs because the ALU is registered.

## ROM

`rom.sv` has two read addresses (`romIn1`, `romIn2`) and two registered 32-bit outputs, initialised with the same 32 register values as the VHDL design. `rom_tb.sv` reads back a few registers and prints them.

## Known issues

- **ROM contents are wrong for registers 5 to 14.** `rom.sv` repeats the register 4 value (`0658E`) and drops the register 14 value (`08B7F`), which shifts registers 5 to 14 by one place. The table needs to match the VHDL one exactly.
- **Illegal opcode behaviour differs from the spec.** The ALU outputs `32'hFFFFFFFF` for an unknown opcode; the specification (and the VHDL design) output `0`.
- **Absolute value operations are commented out** in `alu.sv`.
- **`rom_tb.sv` comments are off by one.** For example the comment says register 10 gives 69723, but 69723 is register 9.
- **The ROM array initialiser is not accepted by every tool.** `assign rom_array = '{ ... }` is rejected by Icarus Verilog. Vivado's simulator is the intended target, but I would prefer an `initial` block or `$readmemh` for portability.
- **The UVM scaffolding in `two/` does not compile.** `alu_if` declares single-bit signals instead of vectors, `alu_tb_top.sv` has a mismatched port connection (`sig_ina`) and stray declarations after `endmodule`, and no UVM components (driver, monitor, scoreboard) exist yet.

## Roadmap

1. Fix the ROM contents and move initialisation to `$readmemh`.
2. Match the VHDL illegal-opcode behaviour and implement the absolute-value operations.
3. Port the decoder, instruction queue and top level.
4. Port the controller and forwarding logic, including the pipelined ROM write address.
5. Fix the interface (`logic [31:0]` vectors) and build out the UVM environment for the ALU, then extend it to the whole processor.
6. Self-checking testbenches that compare against a reference model instead of eyeballing `$monitor` output.

## Repository layout

```
microprocessor-verilog/
└── microprocessor.srcs/sources_1/
    ├── one/        alu.sv, rom.sv and their testbenches (alu_tb.sv, rom_tb.sv)
    └── two/        alu.sv, alu_if.sv, alu_tb_top.sv (UVM-style testbench scaffolding)
```

The project is a Vivado project; the `.gitignore` excludes generated Vivado output (`*.cache`, `*.runs`, `*.sim`, and so on) and the `.xpr` file, so create a new project and add the source folders.

## Running the ALU testbench

In Vivado, create an RTL project, add `one/alu.sv` as a design source and `one/alu_tb.sv` as a simulation source, set `alu_tb` as the top simulation module and run a behavioural simulation.

With Icarus Verilog:

```bash
cd microprocessor.srcs/sources_1
iverilog -g2012 -o alu.vvp one/alu.sv one/alu_tb.sv
vvp alu.vvp
```
