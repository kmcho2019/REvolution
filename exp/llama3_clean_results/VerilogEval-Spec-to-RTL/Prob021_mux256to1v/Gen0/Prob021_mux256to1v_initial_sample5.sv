module TopModule(
    input  [1023:0] in,  // 1024-bit input vector
    input  [7:0] sel,   // 8-bit select signal
    output [3:0] out    // 4-bit output
);

    // Calculate the starting index of the selected group
    wire [10:0] start_idx = sel * 4;

    // Extract the 4-bit group from the input vector
    assign out = in[start_idx +: 4];

endmodule