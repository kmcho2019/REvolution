module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

// Calculate the start position of the 4-bit output within the 1024-bit input vector
wire [9:0] start_pos = {2'b0, sel} * 4;

// Extract the 4-bit output directly from the input vector
assign out = in[start_pos +: 4];

endmodule