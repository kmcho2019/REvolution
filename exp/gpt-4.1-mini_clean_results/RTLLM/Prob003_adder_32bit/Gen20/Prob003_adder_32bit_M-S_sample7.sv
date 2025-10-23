module cla_16bit(
    input  [15:0] A,
    input  [15:0] B,
    input         Cin,
    output [15:0] S,
    output        Cout
);
    wire [15:0] P, G;
    wire [16:0] C;

    assign P = A ^ B;
    assign G = A & B;
    assign C[0] = Cin;

    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : carry_calc
            assign C[i+1] = G[i] | (P[i] & C[i]);
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
    wire c16;

    cla_16bit cla_lower (
        .A(A[16:1]),
        .B(B[16:1]),
        .Cin(1'b0),
        .S(S[16:1]),
        .Cout(c16)
    );

    cla_16bit cla_upper (
        .A(A[32:17]),
        .B(B[32:17]),
        .Cin(c16),
        .S(S[32:17]),
        .Cout(C32)
    );
endmodule