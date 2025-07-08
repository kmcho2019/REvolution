module cla_16bit(
    input  [16:1] A,
    input  [16:1] B,
    input         Cin,
    output [16:1] S,
    output        Cout
);
    wire [16:1] P; // propagate
    wire [16:1] G; // generate
    wire [16:0] C; // carry signals

    assign P = A ^ B;
    assign G = A & B;
    assign C[0] = Cin;

    // Carry lookahead logic for 16 bits
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

    cla_16bit cla_lo(
        .A(A[16:1]),
        .B(B[16:1]),
        .Cin(1'b0),
        .S(S[16:1]),
        .Cout(C16)
    );

    cla_16bit cla_hi(
        .A(A[32:17]),
        .B(B[32:17]),
        .Cin(C16),
        .S(S[32:17]),
        .Cout(C32)
    );
endmodule