module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

// Calculate the index of the 4-bit output
wire [9:0] index = {sel[7:4], sel[3:0]} * 4;

// Directly index into the input vector to select the 4-bit output
assign out = in[index +: 4];

endmodule