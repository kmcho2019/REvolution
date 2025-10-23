module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    // Combine inputs into a 4-bit vector for clarity (a as MSB)
    wire [3:0] input_val = {a, b, c, d};

    // Define conditions where output should be 1
    wire is_2  = (input_val == 4'd2);   // 0010
    wire is_7  = (input_val == 4'd7);   // 0111
    wire is_15 = (input_val == 4'd15);  // 1111

    // Minimal SOP form derivation (from problem):
    // out_sop = a' b' c d' + b c d
    wire sop_term1 = (~a) & (~b) & c & (~d);
    wire sop_term2 = b & c & d;
    assign out_sop = sop_term1 | sop_term2;

    // Minimal POS form derivation (from problem):
    // out_pos = (a + b + c' + d) (b' + c' + d')
    wire pos_sum1 = a | b | (~c) | d;
    wire pos_sum2 = (~b) | (~c) | (~d);
    assign out_pos = pos_sum1 & pos_sum2;

    // For functional correctness, verify output with direct equality:
    // (can comment out or leave for debugging purposes)
    // assign out_sop = is_2 | is_7 | is_15;
    // assign out_pos = out_sop;

endmodule