module cla_4bit (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] S,
    output Cout,
    output G_block,
    output P_block
);
    // Generate and propagate terms
    wire [3:0] G = A & B;
    wire [3:0] P = A ^ B;
    
    // Carry computation
    wire C0 = Cin;
    wire C1 = G[0] | (P[0] & C0);
    wire C2 = G[1] | (P[1] & C1);
    wire C3 = G[2] | (P[2] & C2);
    wire C4 = G[3] | (P[3] & C3);
    
    // Block generate and propagate
    assign G_block = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]);
    assign P_block = P[3] & P[2] & P[1] & P[0];
    
    // Sum and carry outputs
    assign S = P ^ {C3, C2, C1, C0};
    assign Cout = C4;
endmodule

module cla_16bit (
    input [15:0] A,
    input [15:0] B,
    input Cin,
    output [15:0] S,
    output Cout
);
    // Block generate and propagate terms
    wire [3:0] G_block, P_block;
    wire [3:0] carry;
    
    // First level: 4-bit CLAs with generate/propagate outputs
    cla_4bit cla0 (.A(A[3:0]), .B(B[3:0]), .Cin(Cin), 
                 .S(S[3:0]), .G_block(G_block[0]), .P_block(P_block[0]));
    cla_4bit cla1 (.A(A[7:4]), .B(B[7:4]), .Cin(carry[0]), 
                 .S(S[7:4]), .G_block(G_block[1]), .P_block(P_block[1]));
    cla_4bit cla2 (.A(A[11:8]), .B(B[11:8]), .Cin(carry[1]), 
                 .S(S[11:8]), .G_block(G_block[2]), .P_block(P_block[2]));
    cla_4bit cla3 (.A(A[15:12]), .B(B[15:12]), .Cin(carry[2]), 
                 .S(S[15:12]), .G_block(G_block[3]), .P_block(P_block[3]));
    
    // Second level carry lookahead
    assign carry[0] = G_block[0] | (P_block[0] & Cin);
    assign carry[1] = G_block[1] | (P_block[1] & G_block[0]) | (P_block[1] & P_block[0] & Cin);
    assign carry[2] = G_block[2] | (P_block[2] & G_block[1]) | 
                     (P_block[2] & P_block[1] & G_block[0]) | 
                     (P_block[2] & P_block[1] & P_block[0] & Cin);
    assign carry[3] = G_block[3] | (P_block[3] & G_block[2]) | 
                     (P_block[3] & P_block[2] & G_block[1]) | 
                     (P_block[3] & P_block[2] & P_block[1] & G_block[0]) | 
                     (P_block[3] & P_block[2] & P_block[1] & P_block[0] & Cin);
    
    assign Cout = carry[3];
endmodule

module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    // Intermediate signals
    wire G_low, P_low;
    wire C16;
    
    // Lower 16 bits
    cla_16bit low (
        .A(A[16:1]), 
        .B(B[16:1]), 
        .Cin(1'b0), 
        .S(S[16:1]), 
        .Cout(C16)
    );
    
    // Upper 16 bits
    cla_16bit high (
        .A(A[32:17]), 
        .B(B[32:17]), 
        .Cin(C16), 
        .S(S[32:17]), 
        .Cout(C32)
    );
endmodule