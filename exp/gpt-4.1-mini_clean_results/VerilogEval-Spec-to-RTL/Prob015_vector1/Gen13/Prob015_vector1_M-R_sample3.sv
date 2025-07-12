module TopModule (
    input  [15:0] in,
    output [7:0]  out_hi,
    output [7:0]  out_lo
);

    // Use continuous assign with concatenation and bitwise extraction to split input
    assign {out_hi, out_lo} = {in[15:8], in[7:0]};

endmodule