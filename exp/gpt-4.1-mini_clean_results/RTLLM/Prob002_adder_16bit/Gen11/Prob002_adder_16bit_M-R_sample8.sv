module adder_8bit (
    input  [7:0] a,
    input  [7:0] b,
    input        Cin,
    output [7:0] sum,
    output       Cout
);
    wire [7:0] p;    // propagate
    wire [7:0] g;    // generate

    // Calculate propagate and generate
    assign p = a ^ b;
    assign g = a & b;

    // Group propagate and generate for lower nibble (bits 0-3)
    wire P0 = p[0] & p[1] & p[2] & p[3];
    wire G0 = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]);

    // Group propagate and generate for upper nibble (bits 4-7)
    wire P1 = p[4] & p[5] & p[6] & p[7];
    wire G1 = g[7] | (p[7] & g[6]) | (p[7] & p[6] & g[5]) | (p[7] & p[6] & p[5] & g[4]);

    // Carry signals for each bit
    wire c0 = Cin;
    wire c4 = G0 | (P0 & c0);        // Carry into bit 4
    wire c1 = g[0] | (p[0] & c0);
    wire c2 = g[1] | (p[1] & c1);
    wire c3 = g[2] | (p[2] & c2);
    wire c5 = g[4] | (p[4] & c4);
    wire c6 = g[5] | (p[5] & c5);
    wire c7 = g[6] | (p[6] & c6);
    wire c8 = g[7] | (p[7] & c7);    // Carry out of MSB

    // Assign sums
    assign sum[0] = p[0] ^ c0;
    assign sum[1] = p[1] ^ c1;
    assign sum[2] = p[2] ^ c2;
    assign sum[3] = p[3] ^ c3;
    assign sum[4] = p[4] ^ c4;
    assign sum[5] = p[5] ^ c5;
    assign sum[6] = p[6] ^ c6;
    assign sum[7] = p[7] ^ c7;

    assign Cout = c8;

endmodule


module adder_16bit (
    input  [15:0] a,
    input  [15:0] b,
    input         Cin,
    output [15:0] y,
    output        Co
);
    wire carry_mid;

    // Lower 8-bit adder instance
    adder_8bit lower_adder (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .sum(y[7:0]),
        .Cout(carry_mid)
    );

    // Upper 8-bit adder instance
    adder_8bit upper_adder (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(carry_mid),
        .sum(y[15:8]),
        .Cout(Co)
    );
endmodule