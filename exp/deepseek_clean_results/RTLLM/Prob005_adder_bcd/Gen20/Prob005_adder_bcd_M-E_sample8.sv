module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Generate and propagate terms for carry lookahead
    wire [3:0] G = A & B;  // Generate terms
    wire [3:0] P = A ^ B;  // Propagate terms

    // Carry computation with early BCD overflow prediction
    wire c1 = G[0] | (P[0] & Cin);
    wire c2 = G[1] | (P[1] & G[0]) | (P[1] & P[0] & Cin);
    wire c3 = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | 
              (P[2] & P[1] & P[0] & Cin);
    wire c4 = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | 
              (P[3] & P[2] & P[1] & G[0]) | (P[3] & P[2] & P[1] & P[0] & Cin);

    // Early BCD overflow detection (parallel with carry computation)
    wire will_overflow = (A[3] & B[3]) |                     // Both MSBs set
                        ((A[3] | B[3]) & (A[2] & B[2])) |    // Either MSB with both next bits
                        (c4) |                               // Binary carry out
                        ((A[3] | B[3]) & (A[2] | B[2]) & (A[1] | B[1]);  // Sum >= 8 with at least two lower bits

    // Conditional sum computation
    wire [3:0] binary_sum = P ^ {c3, c2, c1, Cin};
    wire [3:0] corrected_sum = binary_sum + 4'b0110;  // +6 correction

    // Output selection
    assign Sum = will_overflow ? corrected_sum : binary_sum;
    assign Cout = will_overflow;

endmodule