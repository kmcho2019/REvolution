module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    // Combine inputs into a 4-bit vector for convenience: a=MSB, d=LSB
    wire [3:0] in_vec = {a, b, c, d};

    // out_sop: 1 only for decimal 2,7,15; else 0
    // Implement via case expression
    assign out_sop = (in_vec == 4'd2) || (in_vec == 4'd7) || (in_vec == 4'd15);

    // out_pos minimal product of sums can be derived from complement of out_sop
    // Here, out_pos = (b' + c' + d') & (a + b + c' + d) as in the previous derivation.

    // For clarity and correctness, implement out_pos via direct assign using input bits:
    wire sum1 = (~b) | (~c) | (~d);
    wire sum2 = a | b | (~c) | d;
    assign out_pos = sum1 & sum2;

endmodule