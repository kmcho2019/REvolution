module TopModule (
    input  [15:0] in,
    output [7:0]  out_hi,
    output [7:0]  out_lo
);

    // Single assignment showing clear relationship between input and outputs
    assign {out_hi, out_lo} = in;

endmodule