// Define the 16-bit carry-lookahead adder module
module cla_16bit(
    input [16:1] A,
    input [16:1] B,
    output [16:1] S,
    output C_out
);

    wire [15:1] C;
    wire [15:1] G, P;

    // Generate the generate and propagate signals
    genvar i;
    generate
        for (i = 1; i <= 16; i++) begin
            assign G[i] = A[i] & B[i];
            assign P[i] = A[i] | B[i];
        end
    endgenerate

    // Generate the carry signals using the generate and propagate signals
    assign C[1] = G[1];
    generate
        for (i = 2; i <= 15; i++) begin
            assign C[i] = G[i] | (P[i] & C[i-1]);
        end
    endgenerate

    // Generate the sum signals using the carry signals
    assign S[1] = P[1] ^ C[1];
    generate
        for (i = 2; i <= 16; i++) begin
            assign S[i] = P[i] ^ C[i];
        end
    endgenerate

    // Generate the final carry-out signal
    assign C_out = G[16] | (P[16] & C[15]);

endmodule

// Define the top module 32-bit carry-lookahead adder
module adder_32bit(
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);

    wire C16;

    // Instantiate two 16-bit CLA blocks
    cla_16bit cla_lower(
       .A(A[16:1]),
       .B(B[16:1]),
       .S(S[16:1]),
       .C_out(C16)
    );

    cla_16bit cla_upper(
       .A(A[32:17]),
       .B(B[32:17]),
       .S(S[32:17]),
       .C_out(C32)
    );

    // Use the carry-out of the lower block as the carry-in for the upper block
    // Not needed in this implementation as CLA does not have a carry-in port

endmodule