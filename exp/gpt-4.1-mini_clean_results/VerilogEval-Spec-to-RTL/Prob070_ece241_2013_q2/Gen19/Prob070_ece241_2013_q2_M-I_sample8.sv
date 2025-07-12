module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);
    // Input vector with 'a' as LSB, 'd' as MSB: {d,c,b,a}
    wire d_c_b_a_3 = d;
    wire d_c_b_a_2 = c;
    wire d_c_b_a_1 = b;
    wire d_c_b_a_0 = a;

    // Minimal SOP for out_sop (1 at decimal 2,7,15):
    // out_sop = d·c·b + d·c·a + d·b·a'
    assign out_sop = (d_c_b_a_3 & d_c_b_a_2 & d_c_b_a_1) 
                   | (d_c_b_a_3 & d_c_b_a_2 & d_c_b_a_0)
                   | (d_c_b_a_3 & d_c_b_a_1 & ~d_c_b_a_0);

    // Minimal POS for out_pos (0 at decimal 0,1,4,5,6,9,10,13,14):
    // out_pos = (a + c + d) · (a + ~b + d) · (~a + b + ~c)
    assign out_pos = (a | c | d) 
                   & (a | ~b | d) 
                   & (~a | b | ~c);

endmodule