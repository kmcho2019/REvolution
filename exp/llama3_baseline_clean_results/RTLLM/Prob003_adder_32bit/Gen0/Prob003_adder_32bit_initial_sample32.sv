// Define the 16-bit Carry-Lookahead Adder (CLA) module
module cla_16bit(
    input [16:1] A,  // 16-bit input operand A
    input [16:1] B,  // 16-bit input operand B
    input Cin,        // Carry-in input
    output [16:1] S,  // 16-bit output representing the sum of A and B
    output Cout        // Carry-out output
);

    // Declare internal signals
    wire [16:1] G;  // Generate signals
    wire [16:1] P;  // Propagate signals
    wire [16:1] C;  // Carry signals

    // Calculate generate (G) and propagate (P) signals
    assign G[1] = A[1] & B[1];
    assign P[1] = A[1] | B[1];
    for (genvar i = 2; i <= 16; i++) begin
        assign G[i] = A[i] & B[i];
        assign P[i] = A[i] | B[i];
    end

    // Calculate carry signals
    assign C[1] = Cin;
    for (genvar i = 2; i <= 16; i++) begin
        assign C[i] = (P[i-1] & C[i-1]) | G[i-1];
    end

    // Calculate sum bits
    assign S[1] = A[1] ^ B[1] ^ Cin;
    for (genvar i = 2; i <= 16; i++) begin
        assign S[i] = A[i] ^ B[i] ^ C[i];
    end

    // Calculate carry-out
    assign Cout = (P[16] & C[16]) | G[16];

endmodule

// Define the top-level 32-bit Carry-Lookahead Adder module
module adder_32bit(
    input [32:1] A,  // 32-bit input operand A
    input [32:1] B,  // 32-bit input operand B
    output [32:1] S,  // 32-bit output representing the sum of A and B
    output C32        // Carry-out output
);

    // Instantiate two 16-bit CLA blocks
    wire Cout_16;
    cla_16bit u1(
        .A(A[16:1]),  // Lower 16 bits of A
        .B(B[16:1]),  // Lower 16 bits of B
        .Cin(1'b0),   // No carry-in for the first block
        .S(S[16:1]),  // Lower 16 bits of S
        .Cout(Cout_16) // Carry-out from the first block
    );

    cla_16bit u2(
        .A(A[32:17]),  // Upper 16 bits of A
        .B(B[32:17]),  // Upper 16 bits of B
        .Cin(Cout_16),  // Carry-in from the first block
        .S(S[32:17]),  // Upper 16 bits of S
        .Cout(C32)      // Final carry-out
    );

endmodule