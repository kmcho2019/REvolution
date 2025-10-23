module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // The output is a 4-bit slice of the input, starting at 4*sel
    assign out = in[4*sel +: 4];

endmodule