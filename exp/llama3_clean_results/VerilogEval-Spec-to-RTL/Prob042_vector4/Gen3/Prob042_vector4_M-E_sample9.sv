module TopModule(
    input  [7:0] in,  // 8-bit input
    output [31:0] out  // 32-bit output
);

// Shift the input 24 bits to the left to make space for sign extension
wire [31:0] shifted_in = in << 24;

// If the sign bit is 1, invert all bits of shifted_in and add 1 to get two's complement
// Otherwise, just use shifted_in as it is
assign out = (in[7] == 1'b1) ? ~(shifted_in) + 1 : shifted_in;

endmodule