// Define a module for a full adder
module full_adder(A, B, Cin, S, Cout);
    input A, B, Cin;
    output S, Cout;
    assign S = A ^ B ^ Cin;
    assign Cout = (A & B) | (A & Cin) | (B & Cin);
endmodule

// Define a module for a 4-bit carry-lookahead adder
module cla_4bit(A, B, Cin, S, Cout);
    input [3:0] A, B;
    input Cin;
    output [3:0] S;
    output Cout;
    wire [2:0] G, P, C;
    
    // Calculate Generate (G) and Propagate (P) signals
    assign G[0] = A[0] & B[0];
    assign P[0] = A[0] | B[0];
    assign G[1] = A[1] & B[1];
    assign P[1] = A[1] | B[1];
    assign G[2] = A[2] & B[2];
    assign P[2] = A[2] | B[2];
    assign G[3] = A[3] & B[3];
    assign P[3] = A[3] | B[3];
    
    // Calculate carry signals
    assign C[0] = Cin;
    assign C[1] = G[0] | (P[0] & Cin);
    assign C[2] = G[1] | (P[1] & C[1]);
    assign C[3] = G[2] | (P[2] & C[2]);
    
    // Calculate sum signals
    assign S[0] = A[0] ^ B[0] ^ Cin;
    assign S[1] = A[1] ^ B[1] ^ C[1];
    assign S[2] = A[2] ^ B[2] ^ C[2];
    assign S[3] = A[3] ^ B[3] ^ C[3];
    
    // Calculate final carry out
    assign Cout = G[3] | (P[3] & C[3]);
endmodule

// Define a module for a 16-bit carry-lookahead adder using 4-bit blocks
module cla_16bit(A, B, Cin, S, Cout);
    input [15:0] A, B;
    input Cin;
    output [15:0] S;
    output Cout;
    wire Cout_4, Cout_8, Cout_12;
    
    cla_4bit u1(A[3:0], B[3:0], Cin, S[3:0], Cout_4);
    cla_4bit u2(A[7:4], B[7:4], Cout_4, S[7:4], Cout_8);
    cla_4bit u3(A[11:8], B[11:8], Cout_8, S[11:8], Cout_12);
    cla_4bit u4(A[15:12], B[15:12], Cout_12, S[15:12], Cout);
endmodule

// Define the top module for a 32-bit carry-lookahead adder
module adder_32bit(A, B, S, C32);
    input [31:1] A, B;
    output [31:1] S;
    output C32;
    wire C16;
    
    cla_16bit u1(A[15:1], B[15:1], 1'b0, S[15:1], C16);
    cla_16bit u2(A[31:16], B[31:16], C16, S[31:16], C32);
endmodule