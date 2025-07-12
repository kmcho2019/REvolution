module TopModule (
    input  [15:0] in,
    output [7:0]  out_hi,
    output [7:0]  out_lo
);
    // Using concatenation to assign bytes explicitly
    assign {out_hi, out_lo} = {in[15:8], in[7:0]};
endmodule