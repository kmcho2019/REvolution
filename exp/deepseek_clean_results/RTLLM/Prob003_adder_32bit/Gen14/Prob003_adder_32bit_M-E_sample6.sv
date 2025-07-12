module cla_4bit (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] S,
    output G,
    output P
);
    wire [3:0] G_bits = A & B;
    wire [3:0] P_bits = A ^ B;
    wire [3:0] C;
    
    assign C[0] = Cin;
    assign C[1] = G_bits[0] | (P_bits[0] & C[0]);
    assign C[2] = G_bits[1] | (P_bits[1] & C[1]);
    assign C[3] = G_bits[2] | (P_bits[2] & C[2]);
    
    assign G = G_bits[3] | (P_bits[3] & G_bits[2]) | 
              (P_bits[3] & P_bits[2] & G_bits[1]) | 
              (P_bits[3] & P_bits[2] & P_bits[1] & G_bits[0]);
    assign P = &P_bits;
    assign S = P_bits ^ C;
endmodule

module cla_8bit (
    input [7:0] A,
    input [7:0] B,
    input Cin,
    output [7:0] S,
    output Cout
);
    wire G0, G1, P0, P1;
    wire carry_mid;
    
    // First 4-bit block
    cla_4bit cla0 (
        .A(A[3:0]),
        .B(B[3:0]),
        .Cin(Cin),
        .S(S[3:0]),
        .G(G0),
        .P(P0)
    );
    
    // Second 4-bit block
    cla_4bit cla1 (
        .A(A[7:4]),
        .B(B[7:4]),
        .Cin(carry_mid),
        .S(S[7:4]),
        .G(G1),
        .P(P1)
    );
    
    // 8-bit carry lookahead logic
    assign carry_mid = G0 | (P0 & Cin);
    assign Cout = G1 | (P1 & G0) | (P1 & P0 & Cin);
endmodule

module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire [3:0] carry;
    
    // First 8-bit block
    cla_8bit cla0 (
        .A(A[8:1]),
        .B(B[8:1]),
        .Cin(1'b0),
        .S(S[8:1]),
        .Cout(carry[0])
    );
    
    // Second 8-bit block
    cla_8bit cla1 (
        .A(A[16:9]),
        .B(B[16:9]),
        .Cin(carry[0]),
        .S(S[16:9]),
        .Cout(carry[1])
    );
    
    // Third 8-bit block
    cla_8bit cla2 (
        .A(A[24:17]),
        .B(B[24:17]),
        .Cin(carry[1]),
        .S(S[24:17]),
        .Cout(carry[2])
    );
    
    // Fourth 8-bit block
    cla_8bit cla3 (
        .A(A[32:25]),
        .B(B[32:25]),
        .Cin(carry[2]),
        .S(S[32:25]),
        .Cout(carry[3])
    );
    
    assign C32 = carry[3];
endmodule