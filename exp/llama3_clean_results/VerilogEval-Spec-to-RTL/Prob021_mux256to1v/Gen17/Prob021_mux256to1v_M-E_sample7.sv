module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

// Calculate the starting index of the desired 4-bit input
wire [10:0] start_index = sel * 4;

// Extract the desired 4-bit output from the 1024-bit input vector
assign out = in[start_index +: 4];

endmodule