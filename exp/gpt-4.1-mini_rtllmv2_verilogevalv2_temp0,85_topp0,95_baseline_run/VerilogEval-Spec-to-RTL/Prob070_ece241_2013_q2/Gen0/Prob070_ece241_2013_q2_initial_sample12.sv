module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    // Minimal SOP: out_sop = b c (a + d)
    assign out_sop = b & c & (a | d);

    // Minimal POS: out_pos = (a + b + d)(a + c + d)
    assign out_pos = (a | b | d) & (a | c | d);

endmodule