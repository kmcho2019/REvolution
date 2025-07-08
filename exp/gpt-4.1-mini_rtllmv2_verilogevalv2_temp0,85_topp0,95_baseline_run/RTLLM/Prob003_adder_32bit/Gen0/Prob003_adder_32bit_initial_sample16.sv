module cla_16bit(
    input  [16:1] A,
    input  [16:1] B,
    input         Cin,
    output [16:1] S,
    output        Cout
);
    wire [16:1] P, G;   // Propagate and generate signals
    wire [16:0] C;      // Carry signals, C[0] = Cin

    assign C[0] = Cin;

    // Generate propagate and generate signals
    assign P = A ^ B;    // Propagate: P = A XOR B
    assign G = A & B;    // Generate: G = A AND B

    // Carry lookahead logic:
    // C[i] = G[i] + (P[i] & C[i-1])
    genvar i;
    generate
        for (i = 1; i <= 16; i = i + 1) begin : carry_gen
            assign C[i] = G[i] | (P[i] & C[i-1]);
        end
    endgenerate

    // Sum calculation
    assign S = P ^ C[15:0];

    assign Cout = C[16];

endmodule

module adder_32bit(
    input  [32:1] A,
    input  [32:1] B,
    output [32:1] S,
    output        C32
);

    wire C16; // Carry-out from lower 16-bit adder

    // Lower 16 bits
    wire [16:1] S_lower;
    cla_16bit cla_low (
        .A(A[16:1]),
        .B(B[16:1]),
        .Cin(1'b0),
        .S(S_lower),
        .Cout(C16)
    );

    // Upper 16 bits
    wire [16:1] S_upper;
    cla_16bit cla_high (
        .A(A[32:17]),
        .B(B[32:17]),
        .Cin(C16),
        .S(S_upper),
        .Cout(C32)
    );

    assign S = {S_upper, S_lower};

endmodule