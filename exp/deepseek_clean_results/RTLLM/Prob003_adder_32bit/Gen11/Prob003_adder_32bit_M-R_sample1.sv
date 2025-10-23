module cla_4bit (
    input  [3:0] A, B,
    input        Cin,
    output [3:0] S,
    output       Cout
);
    wire [3:0] G = A & B;
    wire [3:0] P = A ^ B;
    wire [4:0] C = {G[3] | (P[3] & (G[2] | (P[2] & (G[1] | (P[1] & (G[0] | (P[0] & Cin)))))),
                 G[2] | (P[2] & (G[1] | (P[1] & (G[0] | (P[0] & Cin)))),
                 G[1] | (P[1] & (G[0] | (P[0] & Cin))),
                 G[0] | (P[0] & Cin),
                 Cin};

    assign S = P ^ C[3:0];
    assign Cout = C[4];
endmodule

module cla_16bit (
    input  [15:0] A, B,
    input         Cin,
    output [15:0] S,
    output        Cout
);
    wire [3:0] carry;

    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : cla_block
            cla_4bit cla (
                .A(A[i*4+3:i*4]),
                .B(B[i*4+3:i*4]),
                .Cin(i == 0 ? Cin : carry[i-1]),
                .S(S[i*4+3:i*4]),
                .Cout(carry[i])
            );
        end
    endgenerate

    assign Cout = carry[3];
endmodule

module adder_32bit (
    input  [32:1] A, B,
    output [32:1] S,
    output        C32
);
    wire C16;

    cla_16bit low (
        .A(A[16:1]),
        .B(B[16:1]),
        .Cin(1'b0),
        .S(S[16:1]),
        .Cout(C16)
    );

    cla_16bit high (
        .A(A[32:17]),
        .B(B[32:17]),
        .Cin(C16),
        .S(S[32:17]),
        .Cout(C32)
    );
endmodule