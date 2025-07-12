module TopModule(
    input  [1023:0] in,  // 1024-bit input vector
    input  [7:0] sel,   // 8-bit select signal
    output [3:0] out    // 4-bit output
);

    // Calculate the starting index based on the select signal
    assign out = in[4*sel +: 4];  // Extract the 4-bit value from the input vector

endmodule