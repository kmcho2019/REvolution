module TopModule(
    input  wire [1023:0] in,
    input  wire [7:0]    sel,
    output wire [3:0]    out
);

    // Calculate start index for the selected 4-bit chunk
    wire [9:0] start_idx = sel * 4;

    // Assign the selected 4 bits to output
    assign out = in[start_idx +: 4];

endmodule