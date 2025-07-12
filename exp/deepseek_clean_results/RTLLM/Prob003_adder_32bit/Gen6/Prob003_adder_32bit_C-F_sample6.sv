module cla_4bit (
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
    
    assign C[0] = Cin;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & C[1]);
    assign C[3] = G[2] | (P[2] & C[2]);
    assign Cout = G[3] | (P[3] & C[3]);
    
    assign S = P ^ C;
    assign Gg = G[3] | (G[2] & P[3]) | (G[1] & P[2] & P[3]) | (G[0] & P[1] & P[2] & P[3]);
    assign Pg = P[0] & P[1] & P[2] & P[3];
endmodule

module cla_16bit (
    input [15:0] A,
    input [15:0] B,
    input Cin,
    output [15:0] S,
    output Cout
);
    wire [3:0] carry;
    wire [3:0] Pg, Gg;
    
    cla_4bit cla0 (.A(A[3:0]), .B(B[3:0]), .Cin(Cin), .S(S[3:0]), 
                .Cout(carry[0]), .Pg(Pg[0]), .Gg(Gg[0]));
    cla_4bit cla1 (.A(A[7:4]), .B(B[7:4]), .Cin(carry[0]), .S(S[7:4]), 
                .Cout(carry[1]), .Pg(Pg[1]), .Gg(Gg[1]));
    cla_4bit cla2 (.A(A[11:8]), .B(B[11:8]), .Cin(carry[1]), .S(S[11:8]), 
                .Cout(carry[2]), .Pg(Pg[2]), .Gg(Gg[2]));
    cla_4bit cla3 (.A(A[15:12]), .B(B[15:12]), .Cin(carry[2]), .S(S[15:12]), 
                .Cout(carry[3]), .Pg(Pg[3]), .Gg(Gg[3]));
    
    // Hierarchical lookahead for 16-bit block
    wire [1:0] block_carry;
    assign block_carry[0] = Gg[0] | (Pg[0] & Cin);
    assign block_carry[1] = Gg[1] | (Pg[1] & block_carry[0]);
    assign block_carry[2] = Gg[2] | (Pg[2] & block_carry[1]);
    assign Cout = Gg[3] | (Pg[3] & block_carry[2]);
endmodule

module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire C16;
    wire Pg_low, Gg_low, Pg_high, Gg_high;
    
    cla_16bit low (
        .A(A[16:1]), 
        .B(B[16:1]), 
        .Cin(1'b0), 
        .S(S[16:1]), 
        .Cout(C16)
    );
    
    cla_16bit high (
        .A(A[32:17]), 
        .B(B[32:17]), 
        .Cin(C16), 
        .S(S[32:17]), 
        .Cout(C32)
    );
    
    // Optional: Hierarchical lookahead between 16-bit blocks
    // Would require modifying cla_16bit to output Pg/Gg
endmodule