module TopModule(
    input [1023:0] in,  // 1024-bit input vector
    input [7:0] sel,   // 8-bit select input
    output [3:0] out   // 4-bit output
);

    // Use the sel input to calculate the offset of the desired 4-bit chunk
    // sel * 4 gives the offset of the start of the chunk, and sel * 4 + 3 gives the offset of the end of the chunk
    assign out = in[(sel * 4) + 3:(sel * 4)];

endmodule