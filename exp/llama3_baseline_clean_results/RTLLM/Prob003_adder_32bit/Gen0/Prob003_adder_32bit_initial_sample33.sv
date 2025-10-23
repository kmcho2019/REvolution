// 4-bit CLA block
module cla_4bit(A, B, Cin, S, Cout);
    input [3:0] A;
    input [3:0] B;
    input Cin;
    output [3:0] S;
    output Cout;
    
    wire [3:1] C;
    
    assign S[0] = A[0] ^ B[0] ^ Cin;
    assign C[1] = (A[0] & B[0]) | (A[0] & Cin) | (B[0] & Cin);
    
    assign S[1] = A[1] ^ B[1] ^ C[1];
    assign C[2] = (A[1] & B[1]) | (A[1] & C[1]) | (B[1] & C[1]);
    
    assign S[2] = A[2] ^ B[2] ^ C[2];
    assign C[3] = (A[2] & B[2]) | (A[2] & C[2]) | (B[2] & C[2]);
    
    assign S[3] = A[3] ^ B[3] ^ C[3];
    assign Cout = (A[3] & B[3]) | (A[3] & C[3]) | (B[3] & C[3]);
endmodule

// 16-bit CLA block
module cla_16bit(A, B, Cin, S, Cout);
    input [15:0] A;
    input [15:0] B;
    input Cin;
    output [15:0] S;
    output Cout;
    
    wire C4, C8, C12;
    
    cla_4bit cla0(A[3:0], B[3:0], Cin, S[3:0], C4);
    cla_4bit cla1(A[7:4], B[7:4], C4, S[7:4], C8);
    cla_4bit cla2(A[11:8], B[11:8], C8, S[11:8], C12);
    cla_4bit cla3(A[15:12], B[15:12], C12, S[15:12], Cout);
endmodule

// 32-bit CLA
module adder_32bit(A, B, S, C32);
    input [31:1] A;
    input [31:1] B;
    output [31:1] S;
    output C32;
    
    wire C16;
    
    cla_16bit cla0(A[15:1], B[15:1], 1'b0, S[15:1], C16);
    cla_16bit cla1(A[31:16], B[31:16], C16, S[31:16], C32);
endmodule