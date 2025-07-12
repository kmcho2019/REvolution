// 4-bit CLA block
module cla_4bit(
    input [3:0] A,
    input [3:0] B,
    output [3:0] S,
    output C_out
);
    wire [3:0] G, P;
    wire C1, C2, C3;
    
    assign G[0] = A[0] & B[0];
    assign P[0] = A[0] ^ B[0];
    assign S[0] = P[0] ^ C_out;
    assign C1 = G[0] | (P[0] & C_out);
    
    assign G[1] = A[1] & B[1];
    assign P[1] = A[1] ^ B[1];
    assign S[1] = P[1] ^ C1;
    assign C2 = G[1] | (P[1] & C1);
    
    assign G[2] = A[2] & B[2];
    assign P[2] = A[2] ^ B[2];
    assign S[2] = P[2] ^ C2;
    assign C3 = G[2] | (P[2] & C2);
    
    assign G[3] = A[3] & B[3];
    assign P[3] = A[3] ^ B[3];
    assign S[3] = P[3] ^ C3;
    assign C_out = G[3] | (P[3] & C3);
endmodule

// 16-bit CLA block
module cla_16bit(
    input [15:0] A,
    input [15:0] B,
    output [15:0] S,
    output C_out
);
    wire C4, C8, C12;
    
    cla_4bit cla0(
        .A(A[3:0]),
        .B(B[3:0]),
        .S(S[3:0]),
        .C_out(C4)
    );
    
    cla_4bit cla1(
        .A(A[7:4]),
        .B(B[7:4]),
        .S(S[7:4]),
        .C_out(C8)
    );
    
    cla_4bit cla2(
        .A(A[11:8]),
        .B(B[11:8]),
        .S(S[11:8]),
        .C_out(C12)
    );
    
    cla_4bit cla3(
        .A(A[15:12]),
        .B(B[15:12]),
        .S(S[15:12]),
        .C_out(C_out)
    );
    
    assign S[3] = S[3] ^ C4;
    assign S[7] = S[7] ^ C8;
    assign S[11] = S[11] ^ C12;
endmodule

// 32-bit CLA adder
module adder_32bit(
    input [31:1] A,
    input [31:1] B,
    output [31:1] S,
    output C32
);
    wire C16;
    
    cla_16bit cla0(
        .A(A[15:1]),
        .B(B[15:1]),
        .S(S[15:1]),
        .C_out(C16)
    );
    
    cla_16bit cla1(
        .A(A[31:16]),
        .B(B[31:16]),
        .S(S[31:16]),
        .C_out(C32)
    );
    
    assign S[16] = S[16] ^ C16;
endmodule