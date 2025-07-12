module TopModule (
    input  [15:0] in,
    output [7:0]  out_hi,
    output [7:0]  out_lo
);
    // Directly assign output bytes from concatenated input slices
    assign {out_hi, out_lo} = in;
endmodule