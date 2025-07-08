module cla_16bit(
    input  [16:1] A,
    input  [16:1] B,
    input         Cin,
    output [16:1] S,
    output        Cout
);
    wire [16:1] G; // Generate
    wire [16:1] P; // Propagate
    wire [16:0] C; // Carry signals

    assign G = A & B;
    assign P = A ^ B;

    // Carry lookahead logic:
    // C[0] = Cin
    // C[i] = G[i] | (P[i] & C[i-1]) for i=1 to 16

    assign C[0] = Cin;

    genvar i;
    generate
        for (i = 1; i <= 16; i = i + 1) begin : carry_gen
            assign C[i] = G[i] | (P[i] & C[i-1]);
        end
    endgenerate

    assign S = P ^ C[15:0];
    assign Cout = C[16];
endmodule

module adder_32bit(
    input  [32:1] A,
    input  [32:1] B,
    output [32:1] S,
    output        C32
);
    wire C16;

    // Lower 16 bits adder: bits 1 to 16
    cla_16bit lower_16 (
        .A(A[16:1]),
        .B(B[16:1]),
        .Cin(1'b0),
        .S(S[16:1]),
        .Cout(C16)
    );

    // Upper 16 bits adder: bits 17 to 32
    cla_16bit upper_16 (
        .A(A[32:17]),
        .B(B[32:17]),
        .Cin(C16),
        .S(S[32:17]),
        .Cout(C32)
    );
endmodule