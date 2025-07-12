module TopModule(
    input [1023:0] in,  // 1024-bit input vector
    input [7:0] sel,   // 8-bit select signal
    output [3:0] out   // 4-bit output
);

// Calculate the starting index of the desired 4-bit input
// Since each 4-bit input is spaced 4 bits apart, we multiply sel by 4
assign out = in[(sel * 4) +: 4];

endmodule