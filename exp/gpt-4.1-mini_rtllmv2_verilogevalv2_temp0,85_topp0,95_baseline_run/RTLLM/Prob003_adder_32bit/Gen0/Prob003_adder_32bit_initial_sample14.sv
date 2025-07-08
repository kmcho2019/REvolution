module cla_16bit(
    input  [16:1] A,
    input  [16:1] B,
    input         C0,
    output [16:1] S,
    output        C16
);
    wire [16:1] P;  // propagate
    wire [16:1] G;  // generate
    wire [16:0] C;  // carries, C[0] is C0, C[16] is carry out

    assign C[0] = C0;

    // Generate propagate and generate signals
    assign P = A ^ B;
    assign G = A & B;

    // Carry lookahead logic for 16 bits
    // Carry[i] = G[i] | (P[i] & Carry[i-1])
    // Use a generate block for carry computation

    // Compute carries
    genvar i;
    generate
        for (i=1; i<=16; i=i+1) begin : carry_generate
            assign C[i] = G[i] | (P[i] & C[i-1]);
        end
    endgenerate

    // Sum bits
    assign S = P ^ C[15:0];

    assign C16 = C[16];
endmodule


module adder_32bit(
    input  [32:1] A,
    input  [32:1] B,
    output [32:1] S,
    output        C32
);
    wire C16;  // carry out from lower 16-bit adder

    // Lower 16-bit CLA adder
    cla_16bit cla_lower(
        .A   (A[16:1]),
        .B   (B[16:1]),
        .C0  (1'b0),
        .S   (S[16:1]),
        .C16 (C16)
    );

    // Upper 16-bit CLA adder
    cla_16bit cla_upper(
        .A   (A[32:17]),
        .B   (B[32:17]),
        .C0  (C16),
        .S   (S[32:17]),
        .C16 (C32)
    );
endmodule