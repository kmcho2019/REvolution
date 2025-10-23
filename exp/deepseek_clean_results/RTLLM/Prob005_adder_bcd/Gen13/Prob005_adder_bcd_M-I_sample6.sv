module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Carry lookahead for faster addition
    wire [3:0] G = A & B;  // Generate
    wire [3:0] P = A ^ B;   // Propagate
    wire [3:0] C;
    
    assign C[0] = Cin;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & C[0]);
    assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & C[0]);
    
    // Intermediate sum without carry out
    wire [3:0] S = P ^ C;
    
    // Correction condition (sum > 9 or carry out)
    // Optimized pattern: sum[3]&sum[2] OR sum[3]&sum[1] OR carry_out
    wire correction_needed = (S[3] & (S[2] | S[1])) | (G[3] | (P[3] & C[3]));
    
    // Final sum with correction (either +0 or +6)
    assign Sum = correction_needed ? S + 4'd6 : S;
    
    // Carry out
    assign Cout = correction_needed;

endmodule