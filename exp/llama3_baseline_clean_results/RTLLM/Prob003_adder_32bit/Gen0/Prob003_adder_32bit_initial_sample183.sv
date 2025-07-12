// Define the 16-bit carry-lookahead adder module
module cla_16bit(
    input  [16:1] A,
    input  [16:1] B,
    input  C_in,
    output [16:1] S,
    output C_out
);

    // Internal wires
    wire [16:1] G;  // Generate signal
    wire [16:1] P;  // Propagate signal
    wire [15:0] C;  // Internal carry

    // Calculate Generate and Propagate signals
    genvar i;
    generate
        for (i = 1; i <= 16; i++) begin
            assign G[i] = A[i] & B[i];
            assign P[i] = A[i] | B[i];
        end
    endgenerate

    // Calculate internal carry
    assign C[0] = G[1];
    generate
        for (i = 1; i < 16; i++) begin
            assign C[i] = G[i+1] | (P[i+1] & C[i-1]);
        end
    endgenerate

    // Calculate sum and carry-out
    assign S[1] = P[1] ^ (C_in ^ C[0]);
    generate
        for (i = 1; i < 16; i++) begin
            assign S[i+1] = P[i+1] ^ (C[i-1] ^ C[i]);
        end
    endgenerate
    assign C_out = G[16] | (P[16] & C[15]);

endmodule

// Define the 32-bit carry-lookahead adder module
module adder_32bit(
    input  [32:1] A,
    input  [32:1] B,
    output [32:1] S,
    output C32
);

    // Internal wires
    wire C_mid;

    // Instantiate two 16-bit CLA blocks
    cla_16bit cla_low(
        .A(A[16:1]),
        .B(B[16:1]),
        .C_in(1'b0),
        .S(S[16:1]),
        .C_out(C_mid)
    );

    cla_16bit cla_high(
        .A(A[32:17]),
        .B(B[32:17]),
        .C_in(C_mid),
        .S(S[32:17]),
        .C_out(C32)
    );

endmodule