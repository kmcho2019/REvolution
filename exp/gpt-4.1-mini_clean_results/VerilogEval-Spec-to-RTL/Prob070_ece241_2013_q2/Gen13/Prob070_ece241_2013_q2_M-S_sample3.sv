module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    // Minimal SOP for outputs=1 at 2,7,15:
    // (b & c & d) | (~a & ~b & c & ~d)
    assign out_sop = (b & c & d) | (~a & ~b & c & ~d);

    // Simplify POS by complementing SOP
    assign out_pos = ~out_sop;

endmodule