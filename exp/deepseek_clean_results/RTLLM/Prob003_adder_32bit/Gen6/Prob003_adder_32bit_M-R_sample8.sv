module cla_16bit (
    input [15:0] A,
    input [15:0] B,
    input Cin,
    output [15:0] S,
    output Cout
);
    // 4-bit group generate/propagate
    wire [3:0] G, P;
    wire [3:0] C;
    
    // Generate/propagate for each 4-bit block
    assign G[0] = (A[3:0] & B[3:0]) != 4'b0;
    assign P[0] = (A[3:0] ^ B[3:0]) == 4'b1111;
    assign G[1] = (A[7:4] & B[7:4]) != 4'b0;
    assign P[1] = (A[7:4] ^ B[7:4]) == 4'b1111;
    assign G[2] = (A[11:8] & B[11:8]) != 4'b0;
    assign P[2] = (A[11:8] ^ B[11:8]) == 4'b1111;
    assign G[3] = (A[15:12] & B[15:12]) != 4'b0;
    assign P[3] = (A[15:12] ^ B[15:12]) == 4'b1111;
    
    // Carry lookahead between 4-bit blocks
    assign C[0] = Cin;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & C[1]);
    assign C[3] = G[2] | (P[2] & C[2]);
    assign Cout = G[3] | (P[3] & C[3]);
    
    // Individual 4-bit sums
    assign S[3:0] = A[3:0] ^ B[3:0] ^ {4{C[0]}};
    assign S[7:4] = A[7:4] ^ B[7:4] ^ {4{C[1]}};
    assign S[11:8] = A[11:8] ^ B[11:8] ^ {4{C[2]}};
    assign S[15:12] = A[15:12] ^ B[15:12] ^ {4{C[3]}};
endmodule

module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    // Direct 16-bit CLA implementation without hierarchy
    wire C16;
    
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
endmodule