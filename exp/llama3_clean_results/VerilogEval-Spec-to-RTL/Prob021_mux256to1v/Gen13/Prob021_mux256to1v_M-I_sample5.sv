module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

// Calculate the offset of the desired 4-bit input based on the select signal
wire [9:0] offset = sel * 4;

// Directly select the 4-bit output from the 1024-bit input vector
assign out = in[offset +: 4];

endmodule