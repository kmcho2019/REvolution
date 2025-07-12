module adder_8bit (
    input  [7:0] a,
    input  [7:0] b,
    input        Cin,
    output [7:0] sum,
    output       Cout
);
    wire [7:0] p;  // propagate signals
    wire [7:0] g;  // generate signals

    // Group propagate and generate for lower and upper 4-bit blocks
    wire p_low, g_low;
    wire p_high, g_high;

    // Internal carry wires
    wire c1, c2, c3, c4, c5, c6, c7;

    // Propagate and generate per bit
    assign p = a ^ b;
    assign g = a & b;

    // Compute internal carries with hierarchical carry-lookahead logic

    // Carry into bit 0 is Cin
    // Carry into bit 1
    assign c1 = g[0] | (p[0] & Cin);

    // Carry into bit 2
    assign c2 = g[1] | (p[1] & c1);

    // Carry into bit 3
    assign c3 = g[2] | (p[2] & c2);

    // Carry into bit 4
    assign c4 = g[3] | (p[3] & c3);

    // Generate and propagate for lower 4-bit group
    assign g_low = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]);
    assign p_low = p[3] & p[2] & p[1] & p[0];

    // Carry into bit 5
    assign c5 = g[4] | (p[4] & c4);

    // Carry into bit 6
    assign c6 = g[5] | (p[5] & c5);

    // Carry into bit 7
    assign c7 = g[6] | (p[6] & c6);

    // Generate and propagate for upper 4-bit group
    assign g_high = g[7] | (p[7] & g[6]) | (p[7] & p[6] & g[5]) | (p[7] & p[6] & p[5] & g[4]);
    assign p_high = p[7] & p[6] & p[5] & p[4];

    // Final carry-out
    assign Cout = g_high | (p_high & g_low) | (p_high & p_low & Cin);

    // Sum bits: sum[i] = p[i] ^ carry_in_to_i
    assign sum[0] = p[0] ^ Cin;
    assign sum[1] = p[1] ^ c1;
    assign sum[2] = p[2] ^ c2;
    assign sum[3] = p[3] ^ c3;
    assign sum[4] = p[4] ^ c4;
    assign sum[5] = p[5] ^ c5;
    assign sum[6] = p[6] ^ c6;
    assign sum[7] = p[7] ^ c7;

endmodule

module adder_16bit (
    input  [15:0] a,
    input  [15:0] b,
    input         Cin,
    output [15:0] y,
    output        Co
);
    wire carry_mid;

    adder_8bit lower_adder (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .sum(y[7:0]),
        .Cout(carry_mid)
    );

    adder_8bit upper_adder (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(carry_mid),
        .sum(y[15:8]),
        .Cout(Co)
    );
endmodule