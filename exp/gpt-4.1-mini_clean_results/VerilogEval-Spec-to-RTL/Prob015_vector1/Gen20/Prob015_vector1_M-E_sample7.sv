module TopModule (
    input  [15:0] in,
    output [7:0]  out_hi,
    output [7:0]  out_lo
);
    // Build out_hi by explicitly concatenating bits [15] down to [8]
    assign out_hi = {in[15], in[14], in[13], in[12], in[11], in[10], in[9], in[8]};
    // Build out_lo by explicitly concatenating bits [7] down to [0]
    assign out_lo = {in[7], in[6], in[5], in[4], in[3], in[2], in[1], in[0]};
endmodule