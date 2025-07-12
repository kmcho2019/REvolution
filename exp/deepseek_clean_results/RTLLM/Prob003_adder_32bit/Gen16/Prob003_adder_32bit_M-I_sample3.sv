module cla_4bit_opt (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] S,
    output Pg,  // Block propagate
    output Gg   // Block generate
);
    wire [3:0] G = A & B;
    wire [3:0] P = A ^ B;
    wire [3:0] C;
    
    // Carry computation
    assign C[0] = Cin;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & C[1]);
    assign C[3] = G[2] | (P[2] & C[2]);
    
    // Sum computation
    assign S = P ^ C;
    
    // Block P/G generation
    assign Pg = &P;
    assign Gg = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]);
endmodule

module cla_16bit_opt (
    input [15:0] A,
    input [15:0] B,
    input Cin,
    output [15:0] S,
    output Cout,
    output Pg_block,
    output Gg_block
);
    wire [3:0] Pg, Gg;
    wire [3:0] carry;
    
    // First block has external Cin
    cla_4bit_opt cla0 (.A(A[3:0]), .B(B[3:0]), .Cin(Cin), 
                   .S(S[3:0]), .Pg(Pg[0]), .Gg(Gg[0]));
    
    // Subsequent blocks use lookahead carry
    cla_4bit_opt cla1 (.A(A[7:4]), .B(B[7:4]), .Cin(carry[0]), 
                   .S(S[7:4]), .Pg(Pg[1]), .Gg(Gg[1]));
    cla_4bit_opt cla2 (.A(A[11:8]), .B(B[11:8]), .Cin(carry[1]), 
                   .S(S[11:8]), .Pg(Pg[2]), .Gg(Gg[2]));
    cla_4bit_opt cla3 (.A(A[15:12]), .B(B[15:12]), .Cin(carry[2]), 
                   .S(S[15:12]), .Pg(Pg[3]), .Gg(Gg[3]));
    
    // Block carry lookahead
    assign carry[0] = Gg[0] | (Pg[0] & Cin);
    assign carry[1] = Gg[1] | (Pg[1] & Gg[0]) | (Pg[1] & Pg[0] & Cin);
    assign carry[2] = Gg[2] | (Pg[2] & Gg[1]) | (Pg[2] & Pg[1] & Gg[0]) | 
                     (Pg[2] & Pg[1] & Pg[0] & Cin);
    
    // Block-level P/G for hierarchical lookahead
    assign Pg_block = &Pg;
    assign Gg_block = Gg[3] | (Pg[3] & Gg[2]) | (Pg[3] & Pg[2] & Gg[1]) | 
                     (Pg[3] & Pg[2] & Pg[1] & Gg[0]);
    assign Cout = carry[3];
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
        .Cout(C16),
        .Pg_block(Pg_low),
        .Gg_block(Gg_low)
    );
    
    cla_16bit_opt high (
        .A(A[32:17]), 
        .B(B[32:17]), 
        .Cin(C16), 
        .S(S[32:17]), 
        .Cout(C32),
        .Pg_block(),  // Not needed for top block
        .Gg_block())
    );
endmodule