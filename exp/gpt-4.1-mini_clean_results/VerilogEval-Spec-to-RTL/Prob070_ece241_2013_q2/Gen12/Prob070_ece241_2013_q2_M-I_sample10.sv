module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    // Inputs interpreted as 4-bit number: a (MSB), d (LSB)
    // Function = 1 for decimal inputs 2,7,15
    // 2  = 0 0 1 0
    // 7  = 0 1 1 1
    // 15 = 1 1 1 1
    // Function = 0 for 0,1,4,5,6,9,10,13,14
    // Inputs 3,8,11,12 are don't-cares

    // Minimal SOP including don't-cares:
    // f = (c & d) + (~a & ~b & c & ~d)
    assign out_sop = (c & d) | (~a & ~b & c & ~d);

    // Minimal POS including don't-cares:
    // f = (a + b + ~c + d) & (~a + ~b + c + ~d)
    assign out_pos = (a | b | ~c | d) & (~a | ~b | c | ~d);

endmodule