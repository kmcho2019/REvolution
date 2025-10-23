module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

    // Calculate the starting bit index
    wire [10:0] start_idx = sel * 4;

    // Use the starting index to extract the desired 4-bit chunk
    assign out = in[start_idx +: 4];

endmodule