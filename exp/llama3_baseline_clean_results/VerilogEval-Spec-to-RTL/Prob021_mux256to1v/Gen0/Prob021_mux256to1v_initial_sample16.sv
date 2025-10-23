module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

    // Calculate the starting index based on the select signal
    wire [9:0] start_idx = sel * 4;

    // Use the starting index to extract the 4-bit input from the 1024-bit vector
    assign out = in[start_idx + 3 : start_idx];

endmodule