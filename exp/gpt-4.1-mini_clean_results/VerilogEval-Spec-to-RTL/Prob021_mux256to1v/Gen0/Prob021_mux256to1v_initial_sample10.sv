module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);
    // Calculate the start index of the 4-bit slice
    wire [9:0] start_idx = sel * 4;

    // Extract the 4-bit slice selected by sel
    assign out = in[start_idx +: 4];

endmodule