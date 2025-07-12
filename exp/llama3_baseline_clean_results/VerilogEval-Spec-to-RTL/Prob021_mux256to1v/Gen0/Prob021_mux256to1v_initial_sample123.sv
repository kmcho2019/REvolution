module TopModule(
    input [1023:0] in,
    input [7:0] sel,
    output [3:0] out
);

    // Calculate the starting index of the selected 4-bit chunk
    wire [10:0] start_idx = sel * 4;

    // Use the starting index to extract the selected 4-bit chunk from the input vector
    assign out = in[start_idx + 3 : start_idx];

endmodule