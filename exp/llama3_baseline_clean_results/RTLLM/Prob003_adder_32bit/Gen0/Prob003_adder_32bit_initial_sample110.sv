// 16-bit Carry-Lookahead Adder (CLA) module
module cla_16bit(A, B, Cin, S, Cout);
    input [15:1] A, B;
    input Cin;
    output [15:1] S;
    output Cout;

    wire [15:1] G, P;
    wire [14:1] C;

    // Generate and Propagate signals
    assign G[1] = A[1] & B[1];
    assign P[1] = A[1] | B[1];
    for (genvar i = 2; i <= 15; i++) begin
        assign G[i] = A[i] & B[i];
        assign P[i] = A[i] | B[i];
    end

    // Carry calculation
    assign C[1] = G[1] | (P[1] & Cin);
    for (genvar i = 2; i <= 14; i++) begin
        assign C[i] = G[i] | (P[i] & (G[i-1] | (P[i-1] & C[i-1])));
    end

    // Sum calculation
    assign S[1] = A[1] ^ B[1] ^ Cin;
    for (genvar i = 2; i <= 15; i++) begin
        assign S[i] = A[i] ^ B[i] ^ C[i-1];
    end

    // Carry-out
    assign Cout = G[15] | (P[15] & (G[14] | (P[14] & (G[13] | (P[13] & (G[12] | (P[12] & (G[11] | (P[11] & (G[10] | (P[10] & (G[9] | (P[9] & (G[8] | (P[8] & (G[7] | (P[7] & (G[6] | (P[6] & (G[5] | (P[5] & (G[4] | (P[4] & (G[3] | (P[3] & (G[2] | (P[2] & (G[1] | (P[1] & Cin))))))))))))))))))))))));
endmodule

// Top module: 32-bit Carry-Lookahead Adder
module adder_32bit(A, B, S, C32);
    input [32:1] A, B;
    output [32:1] S;
    output C32;

    wire Cout_16;

    // Instance of 16-bit CLA for lower 16 bits
    cla_16bit cla_lower(
        .A(A[16:1]),
        .B(B[16:1]),
        .Cin(1'b0),
        .S(S[16:1]),
        .Cout(Cout_16)
    );

    // Instance of 16-bit CLA for upper 16 bits
    cla_16bit cla_upper(
        .A(A[32:17]),
        .B(B[32:17]),
        .Cin(Cout_16),
        .S(S[32:17]),
        .Cout(C32)
    );
endmodule