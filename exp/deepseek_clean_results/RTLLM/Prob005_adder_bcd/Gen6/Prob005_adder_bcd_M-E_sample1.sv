module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Generate and Propagate terms
    wire [3:0] G = A & B;
    wire [3:0] P = A ^ B;

    // Kogge-Stone parallel prefix carry computation
    wire [3:0] C;
    assign C[0] = Cin;
    
    // Stage 1
    wire [1:0] G1, P1;
    assign G1[0] = G[0] | (P[0] & C[0]);
    assign P1[0] = P[0] & P[0];
    assign G1[1] = G[1] | (P[1] & G[0]);
    assign P1[1] = P[1] & P[0];
    
    // Stage 2
    wire [3:0] G2, P2;
    assign G2[0] = G1[0];
    assign P2[0] = P1[0];
    assign G2[1] = G1[1];
    assign P2[1] = P1[1];
    assign G2[2] = G[2] | (P[2] & G1[0]);
    assign P2[2] = P[2] & P1[0];
    assign G2[3] = G[3] | (P[3] & G1[1]);
    assign P2[3] = P[3] & P1[1];
    
    // Final carries
    assign C[1] = G2[0] | (P2[0] & C[0]);
    assign C[2] = G2[1] | (P2[1] & C[0]);
    assign C[3] = G2[2] | (P2[2] & C[0]);
    wire C4 = G2[3] | (P2[3] & C[0]);

    // Sum computation with early BCD detection
    wire [3:0] sum_bin = P ^ {C[2], C[1], C[0], Cin};
    
    // BCD overflow detection (parallel computation)
    wire overflow = C4 | (sum_bin[3] & (sum_bin[2] | sum_bin[1]));
    
    // Optimized correction logic (shared XOR trees)
    assign Sum[0] = sum_bin[0] ^ overflow;
    assign Sum[1] = sum_bin[1] ^ overflow ^ (sum_bin[0] & overflow);
    assign Sum[2] = sum_bin[2] ^ overflow ^ (sum_bin[1] & overflow);
    assign Sum[3] = sum_bin[3] ^ overflow ^ (sum_bin[2] & overflow);
    
    assign Cout = overflow;

endmodule