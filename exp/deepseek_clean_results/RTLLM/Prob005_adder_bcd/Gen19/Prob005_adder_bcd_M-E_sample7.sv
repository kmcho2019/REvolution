module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Generate and propagate terms for carry lookahead
    wire [3:0] G = A & B;  // Generate terms
    wire [3:0] P = A | B;  // Propagate terms

    // Intermediate carries
    wire c1 = G[0] | (P[0] & Cin);
    wire c2 = G[1] | (P[1] & G[0]) | (P[1] & P[0] & Cin);
    wire c3 = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & Cin);
    wire c4 = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | 
              (P[3] & P[2] & P[1] & G[0]) | (P[3] & P[2] & P[1] & P[0] & Cin);

    // Compute both possible sums in parallel
    wire [3:0] sum_uncorrected = {1'b0, A} + {1'b0, B} + Cin;
    wire [3:0] sum_corrected = sum_uncorrected + 4'b0110;

    // Early overflow detection (before full sum computation)
    // Overflow occurs if either:
    // 1. Final carry (c4) is set, or
    // 2. Any digit position generates a carry that would make sum > 9
    wire overflow = c4 | 
                   (c3 & (P[3] | G[3])) |  // Sum would be >= 16
                   (G[3] & G[2]) |         // Sum would be >= 12
                   (G[3] & P[2] & (G[1] | P[1] & G[0])); // Sum would be >= 10

    // Select correct sum and carry
    assign Sum = overflow ? sum_corrected[3:0] : sum_uncorrected[3:0];
    assign Cout = overflow;

endmodule