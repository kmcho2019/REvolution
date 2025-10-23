// Define the 16-bit carry-lookahead adder module
module cladder_16bit(
    input [16:1] A,
    input [16:1] B,
    output [16:1] S,
    output C_out
);

    wire [16:1] G;
    wire [16:1] P;
    wire [16:1] C;

    // Calculate generate (G) and propagate (P) signals
    assign G[1] = A[1] & B[1];
    assign P[1] = A[1] | B[1];
    assign C[1] = G[1];

    // Calculate generate (G) and propagate (P) signals for remaining bits
    genvar i;
    generate
        for (i = 2; i <= 16; i = i + 1) begin
            assign G[i] = A[i] & B[i];
            assign P[i] = A[i] | B[i];
            assign C[i] = G[i] | (P[i] & C[i-1]);
        end
    endgenerate

    // Calculate sum (S)
    assign S[1] = P[1] ^ C[1];
    generate
        for (i = 2; i <= 16; i = i + 1) begin
            assign S[i] = P[i] ^ C[i];
        end
    endgenerate

    // Output carry
    assign C_out = C[16];

endmodule

// Define the 32-bit carry-lookahead adder module
module adder_32bit(
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);

    wire C16;

    // First 16-bit CLA block
    cladder_16bit cladder_16bit_1(
       .A(A[16:1]),
       .B(B[16:1]),
       .S(S[16:1]),
       .C_out(C16)
    );

    // Second 16-bit CLA block
    cladder_16bit cladder_16bit_2(
       .A(A[32:17]),
       .B(B[32:17]),
       .S(S[32:17]),
       .C_out(C32)
    );

    // Use carry-out from first 16-bit CLA as input to second 16-bit CLA
    assign S[32:17] = (S[32:17] ^ {16{C16}});

endmodule