module cla_16bit (
    input  [16:1] A,
    input  [16:1] B,
    input         Cin,
    output [16:1] S,
    output        Cout,
    output        P,    // Group propagate
    output        G     // Group generate
);
    wire [16:1] p, g;
    wire [16:0] c;

    assign c[0] = Cin;

    genvar i;
    generate
        for (i = 1; i <= 16; i = i + 1) begin : gen_pg
            assign p[i] = A[i] ^ B[i];
            assign g[i] = A[i] & B[i];
        end
    endgenerate

    generate
        for (i = 1; i <= 16; i = i + 1) begin : gen_carry
            assign c[i] = g[i] | (p[i] & c[i-1]);
        end
    endgenerate

    generate
        for (i = 1; i <= 16; i = i + 1) begin : gen_sum
            assign S[i] = p[i] ^ c[i-1];
        end
    endgenerate

    // Group propagate: AND of all bit propagates
    assign P = &p[16:1];

    // Group generate: simple calculation: 
    // G = g[16] | (p[16] & g[15]) | ... can be simplified as carry out from Cin=0
    // Here, just assign G as the carry out assuming Cin=0
    assign G = c[16];

    assign Cout = c[16];
endmodule


module adder_32bit (
    input  [32:1] A,
    input  [32:1] B,
    output [32:1] S,
    output        C32
);
    wire C16;
    wire P0, G0;
    wire P1, G1;

    cla_16bit cla_low (
        .A   (A[16:1]),
        .B   (B[16:1]),
        .Cin (1'b0),
        .S   (S[16:1]),
        .Cout(C16),
        .P   (P0),
        .G   (G0)
    );

    cla_16bit cla_high (
        .A   (A[32:17]),
        .B   (B[32:17]),
        .Cin (C16),
        .S   (S[32:17]),
        .Cout(C32),
        .P   (P1),
        .G   (G1)
    );
endmodule