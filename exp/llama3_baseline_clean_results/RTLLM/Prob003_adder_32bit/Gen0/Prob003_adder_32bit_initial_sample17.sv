// Define the 16-bit carry-lookahead adder module
module cla_16bit(
    input [15:1] A,  // 16-bit input operand A
    input [15:1] B,  // 16-bit input operand B
    input C_in,      // Carry-in input
    output [15:1] S, // 16-bit output representing the sum of A and B
    output C_out      // Carry-out output
);

    // Generate signals
    wire [15:1] G;  // Generate signals
    wire [15:1] P;  // Propagate signals

    // Calculate generate and propagate signals
    assign G[1] = A[1] & B[1];
    assign P[1] = A[1] | B[1];

    generate
        for (genvar i = 2; i <= 15; i++) begin
            assign G[i] = A[i] & B[i];
            assign P[i] = A[i] | B[i];
        end
    endgenerate

    // Calculate carry signals
    wire [15:1] C;
    assign C[1] = G[1] | (P[1] & C_in);

    generate
        for (genvar i = 2; i <= 15; i++) begin
            assign C[i] = G[i] | (P[i] & C[i-1]);
        end
    endgenerate

    // Calculate sum signals
    assign S[1] = A[1] ^ B[1] ^ C_in;
    generate
        for (genvar i = 2; i <= 15; i++) begin
            assign S[i] = A[i] ^ B[i] ^ C[i-1];
        end
    endgenerate

    // Assign carry-out
    assign C_out = G[15] | (P[15] & C[14]);

endmodule

// Define the 32-bit carry-lookahead adder module
module adder_32bit(
    input [32:1] A,  // 32-bit input operand A
    input [32:1] B,  // 32-bit input operand B
    output [32:1] S, // 32-bit output representing the sum of A and B
    output C32        // Carry-out output
);

    // Instantiate two 16-bit carry-lookahead adder blocks
    wire C16;  // Carry-out of the first 16-bit block
    cla_16bit u1 (
        .A(A[16:1]),  // First 16 bits of A
        .B(B[16:1]),  // First 16 bits of B
        .C_in(1'b0),  // No carry-in for the first block
        .S(S[16:1]),  // First 16 bits of S
        .C_out(C16)   // Carry-out of the first block
    );

    cla_16bit u2 (
        .A(A[32:17]),  // Last 16 bits of A
        .B(B[32:17]),  // Last 16 bits of B
        .C_in(C16),    // Carry-out of the first block as carry-in
        .S(S[32:17]),  // Last 16 bits of S
        .C_out(C32)    // Carry-out of the second block
    );

endmodule