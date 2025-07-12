// 16-bit Carry-Lookahead Adder (CLA) module
module cla_16bit(A, B, Cin, S, Cout);
    input [15:0] A;
    input [15:0] B;
    input Cin;
    output [15:0] S;
    output Cout;

    wire [15:0] P;
    wire [15:0] G;
    wire [15:0] C;

    // Generate P and G signals
    assign P[0] = A[0] ^ B[0];
    assign G[0] = A[0] & B[0];
    assign C[0] = G[0] | (P[0] & Cin);

    // Generate P, G, and C signals for each bit position
    generate
        for (genvar i = 1; i < 16; i++) begin
            assign P[i] = A[i] ^ B[i];
            assign G[i] = A[i] & B[i];
            assign C[i] = G[i] | (P[i] & C[i-1]);
        end
    endgenerate

    // Generate sum signals
    assign S[0] = A[0] ^ B[0] ^ Cin;
    generate
        for (genvar i = 1; i < 16; i++) begin
            assign S[i] = A[i] ^ B[i] ^ C[i-1];
        end
    endgenerate

    // Generate carry-out signal
    assign Cout = G[15] | (P[15] & C[14]);
endmodule

// 32-bit Carry-Lookahead Adder (CLA) module
module adder_32bit(A, B, S, C32);
    input [31:1] A;
    input [31:1] B;
    output [31:1] S;
    output C32;

    wire [15:0] S_low;
    wire [15:0] S_high;
    wire Cout_low;
    wire Cout_high;

    // Instantiate 16-bit CLA for low 16 bits
    cla_16bit cla_low(.A(A[16:1]), .B(B[16:1]), .Cin(1'b0), .S(S_low), .Cout(Cout_low));

    // Instantiate 16-bit CLA for high 16 bits
    cla_16bit cla_high(.A(A[31:16]), .B(B[31:16]), .Cin(Cout_low), .S(S_high), .Cout(Cout_high));

    // Generate final sum signals
    assign S[16:1] = S_low;
    assign S[31:16] = S_high;

    // Generate final carry-out signal
    assign C32 = Cout_high;
endmodule