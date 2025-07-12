module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);
    // Inputs: a=MSB, d=LSB
    // Decimal to binary mapping of inputs {a,b,c,d}
    // 2  = 0 0 1 0
    // 7  = 0 1 1 1
    // 15 = 1 1 1 1

    // Minimal SOP derived using don't-cares:
    // out_sop = (b & c & d) | (~a & ~b & c & ~d);
    assign out_sop = (b & c & d) | (~a & ~b & c & ~d);

    // Minimal POS (product of sums), complement of out_sop:
    // out_pos = (a + b + ~c + d) & (a + ~b + c + d) & (~a + b + c + ~d);
    assign out_pos = (a | b | ~c | d) & (a | ~b | c | d) & (~a | b | c | ~d);

endmodule