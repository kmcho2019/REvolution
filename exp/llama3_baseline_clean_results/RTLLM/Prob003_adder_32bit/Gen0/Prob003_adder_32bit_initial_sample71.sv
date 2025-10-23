// 4-bit carry-lookahead adder
module cla_4bit(
    input  [3:0] A,
    input  [3:0] B,
    output [3:0] S,
    output      C4
);
    wire [3:0] G, P;
    wire C1, C2, C3;
    
    // Generate (G) and Propagate (P) signals
    assign G[0] = A[0] & B[0];
    assign G[1] = A[1] & B[1];
    assign G[2] = A[2] & B[2];
    assign G[3] = A[3] & B[3];
    
    assign P[0] = A[0] | B[0];
    assign P[1] = A[1] | B[1];
    assign P[2] = A[2] | B[2];
    assign P[3] = A[3] | B[3];
    
    // Carry generation
    assign C1 = G[0] | (P[0] & 1'b0);
    assign C2 = G[1] | (P[1] & C1);
    assign C3 = G[2] | (P[2] & C2);
    assign C4 = G[3] | (P[3] & C3);
    
    // Sum generation
    assign S[0] = A[0] ^ B[0];
    assign S[1] = A[1] ^ B[1] ^ C1;
    assign S[2] = A[2] ^ B[2] ^ C2;
    assign S[3] = A[3] ^ B[3] ^ C3;
endmodule

// 16-bit carry-lookahead adder
module cla_16bit(
    input  [15:0] A,
    input  [15:0] B,
    output [15:0] S,
    output      C16
);
    wire C4, C8, C12;
    
    cla_4bit cla_0(
        .A(A[3:0]),
        .B(B[3:0]),
        .S(S[3:0]),
        .C4(C4)
    );
    
    cla_4bit cla_1(
        .A(A[7:4]),
        .B(B[7:4]),
        .S(S[7:4]),
        .C4(C8)
    );
    
    cla_4bit cla_2(
        .A(A[11:8]),
        .B(B[11:8]),
        .S(S[11:8]),
        .C4(C12)
    );
    
    cla_4bit cla_3(
        .A(A[15:12]),
        .B(B[15:12]),
        .S(S[15:12]),
        .C4(C16)
    );
    
    // Add C4, C8, C12 to the next block
    assign S[4] = S[4] ^ C4;
    assign S[8] = S[8] ^ C8;
    assign S[12] = S[12] ^ C12;
endmodule

// 32-bit carry-lookahead adder
module adder_32bit(
    input  [31:1] A,
    input  [31:1] B,
    output [31:1] S,
    output      C32
);
    wire C16;
    
    cla_16bit cla_0(
        .A(A[15:1]),
        .B(B[15:1]),
        .S(S[15:1]),
        .C16(C16)
    );
    
    cla_16bit cla_1(
        .A(A[31:16]),
        .B(B[31:16]),
        .S(S[31:16]),
        .C16(C32)
    );
    
    // Add C16 to the next block
    assign S[16] = S[16] ^ C16;
endmodule