// Define the module for a 16-bit carry-lookahead adder
module cla_16bit(
    input [15:0] A,
    input [15:0] B,
    output [15:0] S,
    output C_out
);

    // Generate and propagate signals
    wire [15:0] G, P;

    // Calculate G and P for each bit position
    genvar i;
    generate
        for (i = 0; i < 16; i++) begin
            assign G[i] = A[i] & B[i];
            assign P[i] = A[i] | B[i];
        end
    endgenerate

    // Carry calculation
    wire [15:0] C;
    assign C[0] = G[0];
    generate
        for (i = 1; i < 16; i++) begin
            assign C[i] = G[i] | (P[i] & C[i-1]);
        end
    endgenerate

    // Sum calculation
    assign S = A ^ B ^ C;
    assign C_out = C[15];

endmodule

// Define the top-level 32-bit adder module
module adder_32bit(
    input [31:1] A,
    input [31:1] B,
    output [31:1] S,
    output C32
);

    // Instance the 16-bit CLA twice
    wire C_16;
    cla_16bit u_cla_lo(
        .A(A[15:1]),
        .B(B[15:1]),
        .S(S[15:1]),
        .C_out(C_16)
    );

    cla_16bit u_cla_hi(
        .A(A[31:16]),
        .B(B[31:16]),
        .S(S[31:16]),
        .C_out(C32)
    );

    // Connect the carry from the lower 16-bit CLA to the higher 16-bit CLA
    // Note: Since we directly instance the CLA modules, the carry is handled internally.

endmodule