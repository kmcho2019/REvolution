module cla_4bit (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] S,
    output Pg,  // Block propagate
    output Gg   // Block generate
);
    wire [3:0] P, G;
    wire [4:0] C;
    
    // Generate and Propagate
    assign P = A ^ B;
    assign G = A & B;
    
    // Brent-Kung prefix tree
    // First level
    wire [3:0] G1, P1;
    assign G1[0] = G[0];
    assign P1[0] = P[0];
    assign G1[1] = G[1] | (P[1] & G[0]);
    assign P1[1] = P[1] & P[0];
    
    // Second level
    wire [3:0] G2, P2;
    assign G2[0] = G1[0];
    assign P2[0] = P1[0];
    assign G2[1] = G1[1];
    assign P2[1] = P1[1];
    assign G2[2] = G[2] | (P[2] & G1[1]);
    assign P2[2] = P[2] & P1[1];
    assign G2[3] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G1[1]);
    assign P2[3] = P[3] & P[2] & P1[1];
    
    // Carry computation
    assign C[0] = Cin;
    assign C[1] = G1[0] | (P1[0] & C[0]);
    assign C[2] = G1[1] | (P1[1] & C[0]);
    assign C[3] = G2[2] | (P2[2] & C[0]);
    assign C[4] = G2[3] | (P2[3] & C[0]);
    
    // Sum and block signals
    assign S = P ^ C[3:0];
    assign Pg = &P;  // Block propagate
    assign Gg = G2[3];  // Block generate
endmodule

module cla_8bit_skip (
    input [7:0] A,
    input [7:0] B,
    input Cin,
    output [7:0] S,
    output Cout,
    output Pg_skip  // For skip logic
);
    wire [1:0] Pg, Gg;
    wire carry_mid;
    
    // Two 4-bit CLAs with shared carry
    cla_4bit cla0 (.A(A[3:0]), .B(B[3:0]), .Cin(Cin), 
                  .S(S[3:0]), .Pg(Pg[0]), .Gg(Gg[0]));
    cla_4bit cla1 (.A(A[7:4]), .B(B[7:4]), 
                  .Cin(Gg[0] | (Pg[0] & Cin)),
                  .S(S[7:4]), .Pg(Pg[1]), .Gg(Gg[1]));
    
    // Skip logic
    assign Pg_skip = Pg[0] & Pg[1];
    assign Cout = Gg[1] | (Pg[1] & Gg[0]) | (Pg_skip & Cin);
endmodule

module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire [3:0] Pg_skip;
    wire [3:0] carry;
    
    // Four 8-bit skip CLAs with optimized carry chain
    cla_8bit_skip cla0 (.A(A[8:1]), .B(B[8:1]), .Cin(1'b0), 
                      .S(S[8:1]), .Cout(carry[0]), .Pg_skip(Pg_skip[0]));
    cla_8bit_skip cla1 (.A(A[16:9]), .B(B[16:9]), 
                      .Cin(carry[0]), .S(S[16:9]), 
                      .Cout(carry[1]), .Pg_skip(Pg_skip[1]));
    cla_8bit_skip cla2 (.A(A[24:17]), .B(B[24:17]), 
                      .Cin(carry[1]), .S(S[24:17]), 
                      .Cout(carry[2]), .Pg_skip(Pg_skip[2]));
    cla_8bit_skip cla3 (.A(A[32:25]), .B(B[32:25]), 
                      .Cin(carry[2]), .S(S[32:25]), 
                      .Cout(carry[3]), .Pg_skip(Pg_skip[3]));
    
    // Global skip logic
    wire global_skip = &Pg_skip;
    assign C32 = global_skip ? carry[0] : carry[3];
endmodule