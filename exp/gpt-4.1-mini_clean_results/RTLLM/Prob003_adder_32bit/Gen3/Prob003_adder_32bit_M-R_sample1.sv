module cla_16bit (
    input  [16:1] A,
    input  [16:1] B,
    input         Cin,
    output [16:1] S,
    output        Cout
);
    wire [16:1] P;   // Propagate
    wire [16:1] G;   // Generate
    wire [16:0] C;   // Carry, C[0]=Cin

    assign C[0] = Cin;

    genvar i;
    // Generate propagate and generate signals
    generate
        for (i = 1; i <= 16; i = i + 1) begin : pg
            assign P[i] = A[i] ^ B[i];
            assign G[i] = A[i] & B[i];
        end
    endgenerate

    // Generate carries in a vectorized manner
    generate
        for (i = 1; i <= 16; i = i + 1) begin : carry_calc
            assign C[i] = G[i] | (P[i] & C[i-1]);
        end
    endgenerate

    // Sum bits
    generate
        for (i = 1; i <= 16; i = i + 1) begin : sum_calc
            assign S[i] = P[i] ^ C[i-1];
        end
    endgenerate

    assign Cout = C[16];
endmodule


module adder_32bit (
    input  [32:1] A,
    input  [32:1] B,
    output [32:1] S,
    output        C32
);
    wire C16;

    // Lower 16-bit CLA
    cla_16bit cla_low (
        .A   (A[16:1]),
        .B   (B[16:1]),
        .Cin (1'b0),
        .S   (S[16:1]),
        .Cout(C16)
    );

    // Upper 16-bit CLA
    cla_16bit cla_high (
        .A   (A[32:17]),
        .B   (B[32:17]),
        .Cin (C16),
        .S   (S[32:17]),
        .Cout(C32)
    );

endmodule