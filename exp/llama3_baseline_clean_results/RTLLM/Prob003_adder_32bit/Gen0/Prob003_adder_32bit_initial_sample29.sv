// Define the 16-bit CLA block
module cla_16bit(
    input [16:1] A,
    input [16:1] B,
    input C_in,
    output [16:1] S,
    output C_out
);

    // Internal signals for generate (G) and propagate (P)
    wire [16:1] G;
    wire [16:1] P;

    // Calculate G and P for each bit position
    genvar i;
    generate
        for (i = 1; i <= 16; i++) begin
            assign G[i] = A[i] & B[i];
            assign P[i] = A[i] | B[i];
        end
    endgenerate

    // Compute the carry signals
    wire [16:1] C;
    assign C[1] = C_in;
    generate
        for (i = 2; i <= 16; i++) begin
            assign C[i] = (G[i-1] | (P[i-1] & C[i-1]));
        end
    endgenerate

    // Compute the sum signals
    assign S = A ^ B ^ C;

    // Compute the carry-out
    assign C_out = G[16] | (P[16] & C[16]);

endmodule

// Define the 32-bit adder using two 16-bit CLA blocks
module adder_32bit(
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);

    // Instantiate two 16-bit CLA blocks
    wire C_mid;
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