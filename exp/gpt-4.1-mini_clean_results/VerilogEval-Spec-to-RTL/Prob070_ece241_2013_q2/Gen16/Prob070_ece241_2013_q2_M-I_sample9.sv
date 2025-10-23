module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    // Minimal SOP: out = a' b' c d' + b c d
    wire term1_sop = (~a) & (~b) & c & (~d);
    wire term2_sop = b & c & d;
    assign out_sop = term1_sop | term2_sop;

    // Minimal POS: out = (a + b + c' + d) (b' + c' + d')
    wire sum1_pos = a | b | (~c) | d;
    wire sum2_pos = (~b) | (~c) | (~d);
    assign out_pos = sum1_pos & sum2_pos;

endmodule