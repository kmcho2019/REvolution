module cla_4bit_opt (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] S,
    output Cout,
    output Pg,
    output Gg
);
    wire [3:0] G = A & B;
    wire [3:0] P = A ^ B;
    wire [3:0] C;
    
    // Optimized carry computation with shared terms
    wire g0_p0c0 = G[0] | (P[0] & Cin);
    wire g1_p1g0 = G[1] | (P[1] & G[0]);
    wire p1_p0 = P[1] & P[0];
    wire g2_p2g1 = G[2] | (P[2] & G[1]);
    wire p2_p1 = P[2] & P[1];
    
    assign C[0] = Cin;
    assign C[1] = g0_p0c0;
    assign C[2] = g1_p1g0 | (p1_p0 & Cin);
    assign C[3] = g2_p2g1 | (p2_p1 & G[0]) | (P[2] & p1_p0 & Cin);
    assign Cout = G[3] | (P[3] & C[3]);
    
    // Block propagate and generate
    assign Pg = &P;
    assign Gg = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]);
    
    assign S = P ^ C;
endmodule

module cla_16bit_opt (
    input [15:0] A,
    input [15:0] B,
    input Cin,
    output [15:0] S,
    output Cout
);
    wire [3:0] carry;
    wire [3:0] Pg, Gg;
    
    cla_4bit_opt cla0 (.A(A[3:0]), .B(B[3:0]), .Cin(Cin), .S(S[3:0]), 
                .Cout(carry[0]), .Pg(Pg[0]), .Gg(Gg[0]));
    cla_4bit_opt cla1 (.A(A[7:4]), .B(B[7:4]), .Cin(carry[0]), .S(S[7:4]), 
                .Cout(carry[1]), .Pg(Pg[1]), .Gg(Gg[1]));
    cla_4bit_opt cla2 (.A(A[11:8]), .B(B[11:8]), .Cin(carry[1]), .S(S[11:8]), 
                .Cout(carry[2]), .Pg(Pg[2]), .Gg(Gg[2]));
    cla_4bit_opt cla3 (.A(A[15:12]), .B(B[15:12]), .Cin(carry[2]), .S(S[15:12]), 
                .Cout(carry[3]), .Pg(Pg[3]), .Gg(Gg[3]));
    
    // Optimized block carry computation
    wire p0_cin = Pg[0] & Cin;
    wire p1_p0_cin = Pg[1] & p0_cin;
    wire p2_p1_p0_cin = Pg[2] & p1_p0_cin;
    
    assign Cout = Gg[3] | 
                 (Pg[3] & Gg[2]) | 
                 (Pg[3] & Pg[2] & Gg[1]) | 
                 (Pg[3] & Pg[2] & Pg[1] & Gg[0]) | 
                 (Pg[3] & Pg[2] & Pg[1] & Pg[0] & Cin);
endmodule

module adder_32bit_opt (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire Pg_low, Gg_low;
    wire C16;
    
    cla_16bit_opt low (
        .A(A[16:1]), 
        .B(B[16:1]), 
        .Cin(1'b0), 
        .S(S[16:1]), 
        .Cout(C16)
    );
    
    cla_16bit_opt high (
        .A(A[32:17]), 
        .B(B[32:17]), 
        .Cin(C16), 
        .S(S[32:17]), 
        .Cout(C32)
    );
endmodule