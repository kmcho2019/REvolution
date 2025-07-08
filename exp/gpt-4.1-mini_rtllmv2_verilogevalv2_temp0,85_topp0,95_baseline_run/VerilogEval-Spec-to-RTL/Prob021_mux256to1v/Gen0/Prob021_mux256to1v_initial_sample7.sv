module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // Calculate starting index for 4-bit slice
    wire [11:0] start_idx = sel * 4;

    // Use variable part select to select 4 bits based on sel
    assign out = in[start_idx +: 4];

endmodule