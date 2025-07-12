module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Predictive correction signals
    wire A_ge5 = A[3] & (A[2] | A[1]);
    wire B_ge5 = B[3] & (B[2] | B[1]);
    wire potential_overflow = A_ge5 & B_ge5;

    // Carry lookahead logic
    wire [3:0] G = A & B;  // Generate terms
    wire [3:0] P = A | B;  // Propagate terms
    wire [3:0] C;
    assign C[0] = Cin;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & C[1]);
    assign C[3] = G[2] | (P[2] & C[2]);
    assign Cout = G[3] | (P[3] & C[3]) | potential_overflow;

    // Correction value (0 or 6) based on prediction
    wire correction_needed = (Cout | (C[3] & (P[3] | P[2])));
    wire [3:0] correction = {4{correction_needed}} & 4'd6;

    // Final sum calculation
    assign Sum = A ^ B ^ C[2:0] ^ correction;

endmodule