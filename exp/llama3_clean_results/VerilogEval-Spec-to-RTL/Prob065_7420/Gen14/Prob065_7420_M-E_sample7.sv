// Define a module for the 4-input NAND gate using a lookup table
module NAND4_LUT(
    input  [3:0] addr,
    output reg y
);

// Initialize the ROM with the truth table of the 4-input NAND gate
reg [1:0] rom[15:0];
initial begin
    rom[0]  = 1'b1; // 0000: 1
    rom[1]  = 1'b1; // 0001: 1
    rom[2]  = 1'b1; // 0010: 1
    rom[3]  = 1'b1; // 0011: 1
    rom[4]  = 1'b1; // 0100: 1
    rom[5]  = 1'b1; // 0101: 1
    rom[6]  = 1'b1; // 0110: 1
    rom[7]  = 1'b1; // 0111: 1
    rom[8]  = 1'b1; // 1000: 1
    rom[9]  = 1'b1; // 1001: 1
    rom[10] = 1'b1; // 1010: 1
    rom[11] = 1'b1; // 1011: 1
    rom[12] = 1'b1; // 1100: 1
    rom[13] = 1'b1; // 1101: 1
    rom[14] = 1'b1; // 1110: 1
    rom[15] = 1'b0; // 1111: 0
end

// Use the input address to select the correct output value from the ROM
always @(*) begin
    y = rom[addr];
end

endmodule

// Define the TopModule using the NAND4_LUT module
module TopModule(
    input  p1a,
    input  p1b,
    input  p1c,
    input  p1d,
    input  p2a,
    input  p2b,
    input  p2c,
    input  p2d,
    output p1y,
    output p2y
);

// Instantiate two NAND4_LUT modules for the two 4-input NAND gates
NAND4_LUT nand1(
  .addr({p1a, p1b, p1c, p1d}),
  .y(p1y)
);

NAND4_LUT nand2(
  .addr({p2a, p2b, p2c, p2d}),
  .y(p2y)
);

endmodule