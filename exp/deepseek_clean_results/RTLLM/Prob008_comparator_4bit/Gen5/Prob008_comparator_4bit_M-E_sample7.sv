module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Generate propagate (equality) and generate (greater) signals
    wire [3:0] P = A ~^ B;  // Bitwise equality
    wire [3:0] G = A & ~B;  // Bitwise greater

    // Carry lookahead comparison logic
    wire G0 = G[3];
    wire G1 = G[2] & P[3];
    wire G2 = G[1] & P[3] & P[2];
    wire G3 = G[0] & P[3] & P[2] & P[1];

    // Combined greater signal
    wire greater = G0 | G1 | G2 | G3;

    // Equal is AND of all propagate signals
    wire equal = &P;

    // Output assignments (mutually exclusive)
    assign A_greater = greater;
    assign A_equal = equal;
    assign A_less = ~equal & ~greater;

endmodule