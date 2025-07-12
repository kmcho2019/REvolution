module cla_8bit (
    input  [7:0] a,
    input  [7:0] b,
    input        Cin,
    output [7:0] y,
    output       Co
);
    wire [7:0] p;  // propagate
    wire [7:0] g;  // generate
    wire [7:1] c;  // internal carries

    // Propagate and generate signals for each bit
    assign p = a ^ b;
    assign g = a & b;

    // Carry lookahead logic
    // c[0] = Cin (external carry input)
    // Carry equations:
    // c[1] = g[0] | (p[0] & c[0])
    // c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & c[0])
    // ...
    assign c[1] = g[0] | (p[0] & Cin);
    assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & Cin);
    assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & Cin);
    assign c[4] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]) | (p[3] & p[2] & p[1] & p[0] & Cin);
    assign c[5] = g[4] | (p[4] & g[3]) | (p[4] & p[3] & g[2]) | (p[4] & p[3] & p[2] & g[1]) | (p[4] & p[3] & p[2] & p[1] & g[0]) | (p[4] & p[3] & p[2] & p[1] & p[0] & Cin);
    assign c[6] = g[5] | (p[5] & g[4]) | (p[5] & p[4] & g[3]) | (p[5] & p[4] & p[3] & g[2]) | (p[5] & p[4] & p[3] & p[2] & g[1]) | (p[5] & p[4] & p[3] & p[2] & p[1] & g[0]) | (p[5] & p[4] & p[3] & p[2] & p[1] & p[0] & Cin);
    assign c[7] = g[6] | (p[6] & g[5]) | (p[6] & p[5] & g[4]) | (p[6] & p[5] & p[4] & g[3]) | (p[6] & p[5] & p[4] & p[3] & g[2]) | (p[6] & p[5] & p[4] & p[3] & p[2] & g[1]) | (p[6] & p[5] & p[4] & p[3] & p[2] & p[1] & g[0]) | (p[6] & p[5] & p[4] & p[3] & p[2] & p[1] & p[0] & Cin);

    // Final carry out for 8th bit
    assign Co = g[7] | (p[7] & c[7]);

    // Sum bits
    assign y[0] = p[0] ^ Cin;
    genvar i;
    generate
        for (i = 1; i < 8; i = i + 1) begin : sum_bits
            assign y[i] = p[i] ^ c[i];
        end
    endgenerate
endmodule


module adder_16bit (
    input  [15:0] a,
    input  [15:0] b,
    input         Cin,
    output [15:0] y,
    output        Co
);
    wire c_mid;
    wire [7:0] sum_low, sum_high;

    // Lower 8-bit CLA
    cla_8bit low_part (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(sum_low),
        .Co(c_mid)
    );

    // Upper 8-bit CLA
    cla_8bit high_part (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(c_mid),
        .y(sum_high),
        .Co(Co)
    );

    assign y = {sum_high, sum_low};
endmodule