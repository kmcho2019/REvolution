module TopModule (
    input  [15:0] in,
    output [7:0]  out_hi,
    output [7:0]  out_lo
);

    // Use concatenation to assign out_hi and out_lo simultaneously from input slices
    assign {out_hi, out_lo} = {in[15:8], in[7:0]};

endmodule