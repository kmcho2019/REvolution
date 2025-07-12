module TopModule (
    input  [15:0] in,
    output [7:0]  out_hi,
    output [7:0]  out_lo
);

    // Use concatenation to explicitly show the split operation
    assign {out_hi, out_lo} = in;

endmodule