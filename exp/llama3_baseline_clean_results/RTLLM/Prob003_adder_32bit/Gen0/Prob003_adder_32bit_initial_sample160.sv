// Define the 16-bit CLA block
module cla_16bit(
    input [16:1] A,
    input [16:1] B,
    input C_in,
    output [16:1] S,
    output C_out
);

    wire [16:1] G, P;
    wire [15:0] C;

    // Calculate generate and propagate signals
    assign G[1] = A[1] & B[1];
    assign P[1] = A[1] | B[1];
    assign C[0] = C_in;

    genvar i;
    generate
        for (i = 2; i <= 16; i++) begin
            assign G[i] = A[i] & B[i];
            assign P[i] = A[i] | B[i];
            assign C[i-1] = G[i-1] | (P[i-1] & C[i-2]);
        end
    endgenerate

    // Calculate sum
    assign S[1] = A[1] ^ B[1] ^ C_in;
    assign C_out = G[16] | (P[16] & C[15]);

    generate
        for (i = 2; i <= 16; i++) begin
            assign S[i] = A[i] ^ B[i] ^ C[i-1];
        end
    endgenerate

endmodule

// Define the 32-bit carry-lookahead adder
module adder_32bit(
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);

    wire C16;

    // Instantiate two 16-bit CLA blocks
    cla_16bit cla1(
        .A(A[16:1]),
        .B(B[16:1]),
        .C_in(1'b0),
        .S(S[16:1]),
        .C_out(C16)
    );

    cla_16bit cla2(
        .A(A[32:17]),
        .B(B[32:17]),
        .C_in(C16),
        .S(S[32:17]),
        .C_out(C32)
    );

endmodule