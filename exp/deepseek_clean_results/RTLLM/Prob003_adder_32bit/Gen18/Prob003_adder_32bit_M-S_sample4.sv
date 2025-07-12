module cla_16bit (
    input [15:0] A,
    input [15:0] B,
    input Cin,
    output [15:0] S,
    output Cout
);
    wire [15:0] P = A ^ B;
    wire [15:0] G = A & B;
    
    // Compute carries and sum in one step
    assign S[0] = P[0] ^ Cin;
    assign S[1] = P[1] ^ (G[0] | (P[0] & Cin));
    assign S[2] = P[2] ^ (G[1] | (P[1] & (G[0] | (P[0] & Cin))));
    assign S[3] = P[3] ^ (G[2] | (P[2] & (G[1] | (P[1] & (G[0] | (P[0] & Cin))))));
    assign S[4] = P[4] ^ (G[3] | (P[3] & (G[2] | (P[2] & (G[1] | (P[1] & (G[0] | (P[0] & Cin))))))));
    assign S[5] = P[5] ^ (G[4] | (P[4] & (G[3] | (P[3] & (G[2] | (P[2] & (G[1] | (P[1] & (G[0] | (P[0] & Cin))))))))));
    assign S[6] = P[6] ^ (G[5] | (P[5] & (G[4] | (P[4] & (G[3] | (P[3] & (G[2] | (P[2] & (G[1] | (P[1] & (G[0] | (P[0] & Cin))))))))))));
    assign S[7] = P[7] ^ (G[6] | (P[6] & (G[5] | (P[5] & (G[4] | (P[4] & (G[3] | (P[3] & (G[2] | (P[2] & (G[1] | (P[1] & (G[0] | (P[0] & Cin))))))))))))));
    assign S[15:8] = P[15:8] ^ {G[14:7] | (P[14:7] & {G[13:6] | (P[13:6] & {G[12:5] | (P[12:5] & {G[11:4] | (P[11:4] & {G[10:3] | (P[10:3] & {G[9:2] | (P[9:2] & {G[8:1] | (P[8:1] & {G[7:0] | (P[7:0] & {G[6:0] | (P[6:0] & Cin), P[0] & Cin})})})})})})})};
    
    assign Cout = G[15] | (P[15] & (G[14] | (P[14] & (G[13] | (P[13] & (G[12] | (P[12] & (G[11] | (P[11] & (G[10] | (P[10] & (G[9] | (P[9] & (G[8] | (P[8] & (G[7] | (P[7] & (G[6] | (P[6] & (G[5] | (P[5] & (G[4] | (P[4] & (G[3] | (P[3] & (G[2] | (P[2] & (G[1] | (P[1] & (G[0] | (P[0] & Cin))))))))))))))))))))))))))));
endmodule

module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
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