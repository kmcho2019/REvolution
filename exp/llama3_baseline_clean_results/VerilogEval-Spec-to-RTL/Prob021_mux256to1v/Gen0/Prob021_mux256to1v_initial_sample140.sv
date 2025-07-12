module TopModule(
    input [1023:0] in,  // 1024-bit input vector
    input [7:0] sel,     // 8-bit select signal
    output [3:0] out     // 4-bit output
);

// Calculate the starting index of the 4-bit input
wire [9:0] index = sel * 4;

// Extract the corresponding 4-bit input from the input vector
assign out = in[index + 3 : index];

endmodule