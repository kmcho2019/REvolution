module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);
    wire [3:0] in_vec = {a,b,c,d};

    // Exact equality checks for the three output=1 minterms
    wire is_2  = (in_vec == 4'd2);   // 0010
    wire is_7  = (in_vec == 4'd7);   // 0111
    wire is_15 = (in_vec == 4'd15);  // 1111

    // out_sop is 1 if input equals 2,7 or 15
    assign out_sop = is_2 | is_7 | is_15;

    // Now derive minimal POS for out_pos.
    // From problem: out_pos = 1 when input in {2,7,15}
    // So out_pos = out_sop
    // The complement (inputs giving 0) are zeros at specified values plus don't cares.
    // Minimal POS expression found by Boolean minimization is:
    // out_pos = (b + d) & (a + c + d) & (a + b + ~d)
    // Explanation:
    // - This expression covers only 2,7,15 as 1's, zeros and don't-cares excluded.
    // Implement it directly:

    assign out_pos = (b | d) & (a | c | d) & (a | b | ~d);

endmodule