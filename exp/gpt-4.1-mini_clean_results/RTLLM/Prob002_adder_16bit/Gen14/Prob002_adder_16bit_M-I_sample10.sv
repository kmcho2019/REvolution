module adder_8bit (
    input  [7:0] a,
    input  [7:0] b,
    input        Cin,
    output [7:0] y,
    output       Co
);
    // Generate and Propagate signals for each bit
    wire [7:0] G; // Generate
    wire [7:0] P; // Propagate
    wire [8:0] carry;

    assign G = a & b;
    assign P = a ^ b;
    assign carry[0] = Cin;

    // Carry lookahead logic:
    // carry[i+1] = G[i] | (P[i] & carry[i])
    assign carry[1] = G[0] | (P[0] & carry[0]);
    assign carry[2] = G[1] | (P[1] & carry[1]);
    assign carry[3] = G[2] | (P[2] & carry[2]);
    assign carry[4] = G[3] | (P[3] & carry[3]);
    assign carry[5] = G[4] | (P[4] & carry[4]);
    assign carry[6] = G[5] | (P[5] & carry[5]);
    assign carry[7] = G[6] | (P[6] & carry[6]);
    assign carry[8] = G[7] | (P[7] & carry[7]);

    // Sum bits
    assign y = P ^ carry[7:0];

    assign Co = carry[8];
endmodule


module adder_16bit (
    input  [15:0] a,
    input  [15:0] b,
    input         Cin,
    output [15:0] y,
    output        Co
);
    wire carry_mid;

    adder_8bit low_adder (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(carry_mid)
    );

    adder_8bit high_adder (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(carry_mid),
        .y(y[15:8]),
        .Co(Co)
    );
endmodule