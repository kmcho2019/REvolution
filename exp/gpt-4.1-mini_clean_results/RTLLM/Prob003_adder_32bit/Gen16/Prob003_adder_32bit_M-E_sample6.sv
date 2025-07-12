module cla_4bit (
    input  [4:1] A,
    input  [4:1] B,
    input        Cin,
    output [4:1] S,
    output       Cout,
    output       Gout,  // group generate
    output       Pout   // group propagate
);
    wire [4:1] P; // propagate signals
    wire [4:1] G; // generate signals
    wire [4:0] C; // carry signals

    assign P = A ^ B;
    assign G = A & B;
    assign C[0] = Cin;

    // Carry lookahead logic
    assign C[1] = G[1] | (P[1] & C[0]);
    assign C[2] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & C[0]);
    assign C[3] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & C[0]);
    assign C[4] = G[4] | (P[4] & G[3]) | (P[4] & P[3] & G[2]) | (P[4] & P[3] & P[2] & G[1]) | (P[4] & P[3] & P[2] & P[1] & C[0]);

    assign S = P ^ C[3:0];
    assign Cout = C[4];

    // Group generate and propagate for higher-level CLA
    assign Gout = G[4] | (P[4] & G[3]) | (P[4] & P[3] & G[2]) | (P[4] & P[3] & P[2] & G[1]);
    assign Pout = P[4] & P[3] & P[2] & P[1];
endmodule


module cla_16bit (
    input  [16:1] A,
    input  [16:1] B,
    input         Cin,
    output [16:1] S,
    output        Cout
);
    wire [3:0] c_internal;  // carries between 4-bit blocks
    wire [3:0] G;           // group generate from 4-bit blocks
    wire [3:0] P;           // group propagate from 4-bit blocks

    // Instantiate four 4-bit CLAs for 16-bit input
    cla_4bit cla0 (
        .A    (A[4:1]),
        .B    (B[4:1]),
        .Cin  (Cin),
        .S    (S[4:1]),
        .Cout (),
        .Gout (G[0]),
        .Pout (P[0])
    );

    cla_4bit cla1 (
        .A    (A[8:5]),
        .B    (B[8:5]),
        .Cin  (c_internal[0]),
        .S    (S[8:5]),
        .Cout (),
        .Gout (G[1]),
        .Pout (P[1])
    );

    cla_4bit cla2 (
        .A    (A[12:9]),
        .B    (B[12:9]),
        .Cin  (c_internal[1]),
        .S    (S[12:9]),
        .Cout (),
        .Gout (G[2]),
        .Pout (P[2])
    );

    cla_4bit cla3 (
        .A    (A[16:13]),
        .B    (B[16:13]),
        .Cin  (c_internal[2]),
        .S    (S[16:13]),
        .Cout (),
        .Gout (G[3]),
        .Pout (P[3])
    );

    // Compute carries between 4-bit blocks using group generate/propagate
    wire c0, c1, c2, c3, c4;
    assign c0 = Cin;
    assign c1 = G[0] | (P[0] & c0);
    assign c2 = G[1] | (P[1] & G[0]) | (P[1] & P[0] & c0);
    assign c3 = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & c0);
    assign c4 = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) | (P[3] & P[2] & P[1] & P[0] & c0);

    assign c_internal = {c3, c2, c1, c0};
    assign Cout = c4;
endmodule


module adder_32bit (
    input  [32:1] A,
    input  [32:1] B,
    output [32:1] S,
    output        C32
);
    wire C16;

    cla_16bit cla_lower (
        .A    (A[16:1]),
        .B    (B[16:1]),
        .Cin  (1'b0),
        .S    (S[16:1]),
        .Cout (C16)
    );

    cla_16bit cla_upper (
        .A    (A[32:17]),
        .B    (B[32:17]),
        .Cin  (C16),
        .S    (S[32:17]),
        .Cout (C32)
    );
endmodule