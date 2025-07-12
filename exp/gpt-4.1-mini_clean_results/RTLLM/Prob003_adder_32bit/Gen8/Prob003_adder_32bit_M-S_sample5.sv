module cla_16bit (
    input  [16:1] A,
    input  [16:1] B,
    input         Cin,
    output [16:1] S,
    output        Cout
);
    wire [16:1] p, g;
    wire [16:0] c;

    assign c[0] = Cin;

    genvar i;
    generate
        for (i = 1; i <= 16; i = i + 1) begin : pg_loop
            assign p[i] = A[i] ^ B[i];
            assign g[i] = A[i] & B[i];
            assign c[i] = g[i] | (p[i] & c[i-1]);
            assign S[i] = p[i] ^ c[i-1];
        end
    endgenerate

    assign Cout = c[16];
endmodule

module adder_32bit (
    input  [32:1] A,
    input  [32:1] B,
    output [32:1] S,
    output        C32
);
    wire C16;

    cla_16bit cla_low (
        .A   (A[16:1]),
        .B   (B[16:1]),
        .Cin (1'b0),
        .S   (S[16:1]),
        .Cout(C16)
    );

    cla_16bit cla_high (
        .A   (A[32:17]),
        .B   (B[32:17]),
        .Cin (C16),
        .S   (S[32:17]),
        .Cout(C32)
    );
endmodule