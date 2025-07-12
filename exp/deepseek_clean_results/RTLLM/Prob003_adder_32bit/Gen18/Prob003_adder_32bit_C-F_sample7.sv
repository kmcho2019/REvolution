module cla_4bit (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] S,
    output Cout
);
    wire [3:0] G = A & B;
    wire [3:0] P = A ^ B;
    wire [2:0] C;
    
    assign C[0] = G[0] | (P[0] & Cin);
    assign C[1] = G[1] | (P[1] & C[0]);
    assign C[2] = G[2] | (P[2] & C[1]);
    assign Cout = G[3] | (P[3] & C[2]);
    
    assign S = P ^ {C, Cin};
endmodule

module cla_16bit (
    input [15:0] A,
    input [15:0] B,
    input Cin,
    output [15:0] S,
    output Cout
);
    wire [3:0] carry;
    
    cla_4bit cla0 (A[3:0], B[3:0], Cin, S[3:0], carry[0]);
    cla_4bit cla1 (A[7:4], B[7:4], carry[0], S[7:4], carry[1]);
    cla_4bit cla2 (A[11:8], B[11:8], carry[1], S[11:8], carry[2]);
    cla_4bit cla3 (A[15:12], B[15:12], carry[2], S[15:12], carry[3]);
    
    assign Cout = carry[3];
endmodule

module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire C16;
    
    cla_16bit low (A[16:1], B[16:1], 1'b0, S[16:1], C16);
    cla_16bit high (A[32:17], B[32:17], C16, S[32:17], C32);
endmodule