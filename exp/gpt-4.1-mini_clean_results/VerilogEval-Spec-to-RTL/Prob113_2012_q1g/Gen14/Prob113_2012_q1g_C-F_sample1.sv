module TopModule(
    input  [3:0] x,
    output       f
);

    wire x3 = x[3];
    wire x2 = x[2];
    wire x1 = x[1];
    wire x0 = x[0];

    // Complements
    wire nx3 = ~x3;
    wire nx1 = ~x1;
    wire nx0 = ~x0;

    // Term1: ~x3 & ~x1
    wire term1 = nx3 & nx1;

    // Term2: ~x3 & x2 & x1 & ~x0 (decomposed)
    wire t2_mid1 = nx3 & x2;      // 2-input AND
    wire t2_mid2 = x1 & nx0;      // 2-input AND
    wire term2 = t2_mid1 & t2_mid2; // 4-input AND decomposed

    // Term3: x3 & x2 & (~x0 | x1)  [simplified inner OR]
    wire or_inner = nx0 | x1;     // (~x0 | x1)
    wire t3_mid = x3 & x2;        // 2-input AND
    wire term3 = t3_mid & or_inner;

    // Final output
    assign f = term1 | term2 | term3;

endmodule