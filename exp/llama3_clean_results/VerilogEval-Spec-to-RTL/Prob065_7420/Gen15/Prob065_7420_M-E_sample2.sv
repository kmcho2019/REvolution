// Define a module for a 4-input LUT-based NAND gate
module LUT_NAND4(
    input  [3:0] addr, // Address lines for the LUT
    output reg  y      // Output of the NAND gate
);

// Initialize the LUT with values corresponding to a 4-input NAND gate
reg [0:15] lut_values = {
    1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
    1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0
};

// Use the LUT to generate the output
always @(*) begin
    y = lut_values[addr];
end

endmodule

// Instantiate the LUT_NAND4 modules twice within the TopModule
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

// Concatenate the input bits to form the address for the LUT
wire [3:0] addr1 = {p1a, p1b, p1c, p1d};
wire [3:0] addr2 = {p2a, p2b, p2c, p2d};

// Instantiate LUT_NAND4 modules for the first and second sets of inputs
LUT_NAND4 nand1(
  .addr(addr1),
  .y(p1y)
);

LUT_NAND4 nand2(
  .addr(addr2),
  .y(p2y)
);

endmodule