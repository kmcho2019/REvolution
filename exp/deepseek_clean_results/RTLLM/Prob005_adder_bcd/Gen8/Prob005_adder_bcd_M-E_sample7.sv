module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Stage 1: Generate Propagate and Generate terms
    wire [3:0] P = A ^ B;
    wire [3:0] G = A & B;

    // Stage 2: Kogge-Stone parallel prefix network (4-bit)
    wire [3:0] G1, P1;
    wire [3:0] G2, P2;
    
    // First level prefix
    assign G1[0] = G[0] | (P[0] & Cin);
    assign P1[0] = P[0];
    assign G1[3:1] = G[3:1] | (P[3:1] & G[2:0]);
    assign P1[3:1] = P[3:1] & P[2:0];
    
    // Second level prefix
    assign G2[1:0] = G1[1:0];
    assign P2[1:0] = P1[1:0];
    assign G2[3:2] = G1[3:2] | (P1[3:2] & G1[1:0]);
    assign P2[3:2] = P1[3:2] & P1[1:0];
    
    // Final carry computation with early BCD detection
    wire [3:0] C;
    assign C[0] = Cin;
    assign C[1] = G1[0];
    assign C[2] = G2[1];
    assign C[3] = G2[2];
    
    // Sum computation with integrated BCD correction
    wire [3:0] sum_bin = P ^ {C[2], C[1], C[0], Cin};
    wire need_correction = (G2[3] | (P2[3] & G2[2])) |  // Binary carry out
                         (sum_bin[3] & sum_bin[2]) |   // 12-15
                         (sum_bin[3] & sum_bin[1]);    // 10-11
    
    // Corrected sum and carry out
    assign Sum = need_correction ? sum_bin + 4'd6 : sum_bin;
    assign Cout = need_correction;

endmodule