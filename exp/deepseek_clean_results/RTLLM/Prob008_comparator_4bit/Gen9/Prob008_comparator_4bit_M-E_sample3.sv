module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Generate (G) and Propagate (P) signals for each bit
    wire [3:0] G = A & ~B;  // A > B at this bit position
    wire [3:0] P = ~(A ^ B); // A == B at this bit position

    // Prefix computation for greater-than
    wire gt3 = G[3];
    wire gt2 = P[3] & G[2];
    wire gt1 = &P[3:2] & G[1];
    wire gt0 = &P[3:1] & G[0];

    // Final greater-than result (OR reduction of prefix terms)
    wire greater = gt3 | gt2 | gt1 | gt0;

    // Equality is AND reduction of propagate signals
    wire equal = &P;

    // Output assignments (mutually exclusive)
    assign A_equal = equal;
    assign A_greater = greater;
    assign A_less = ~equal & ~greater;

endmodule