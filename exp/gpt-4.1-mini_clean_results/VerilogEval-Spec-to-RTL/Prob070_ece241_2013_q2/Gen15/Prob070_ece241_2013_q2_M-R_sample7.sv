module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    // Combine inputs into 4-bit vector for clarity
    wire [3:0] num = {a, b, c, d};

    // out_sop: logic 1 for decimal inputs 2,7,15; else 0
    // Using direct comparisons:
    assign out_sop = (num == 4'd2) | (num == 4'd7) | (num == 4'd15);

    // Minimal POS form derived:
    // out_pos = (b' + c' + d') & (a + b + c' + d)
    // Expressed in terms of inputs:
    wire sum1 = (~b) | (~c) | (~d);
    wire sum2 = a | b | (~c) | d;
    assign out_pos = sum1 & sum2;

endmodule