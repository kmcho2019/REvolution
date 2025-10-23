// Define the module for a 1-bit full adder
module adder_1bit(
    input a,
    input b,
    input Cin,
    output y,
    output Co
);
    assign y = a ^ b ^ Cin;
    assign Co = (a & b) | (a & Cin) | (b & Cin);
endmodule

// Define the module for an 8-bit full adder using carry-lookahead
module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);
    wire [7:1] carry;

    // Generate group propagate and generate signals
    wire [7:0] p, g;
    assign p = a | b;
    assign g = a & b;

    // Calculate carry signals using lookahead
    wire c1, c2, c3, c4, c5, c6, c7;
    assign c1 = g[0] | (p[0] & Cin);
    assign c2 = g[1] | (p[1] & (g[0] | (p[0] & Cin)));
    assign c3 = g[2] | (p[2] & (g[1] | (p[1] & (g[0] | (p[0] & Cin)))));
    assign c4 = g[3] | (p[3] & (g[2] | (p[2] & (g[1] | (p[1] & (g[0] | (p[0] & Cin)))))));
    assign c5 = g[4] | (p[4] & (g[3] | (p[3] & (g[2] | (p[2] & (g[1] | (p[1] & (g[0] | (p[0] & Cin))))))));
    assign c6 = g[5] | (p[5] & (g[4] | (p[4] & (g[3] | (p[3] & (g[2] | (p[2] & (g[1] | (p[1] & (g[0] | (p[0] & Cin))))))))));
    assign c7 = g[6] | (p[6] & (g[5] | (p[5] & (g[4] | (p[4] & (g[3] | (p[3] & (g[2] | (p[2] & (g[1] | (p[1] & (g[0] | (p[0] & Cin)))))))))));

    // Calculate sum bits using the carry lookahead signals
    assign y[0] = a[0] ^ b[0] ^ Cin;
    assign y[1] = a[1] ^ b[1] ^ c1;
    assign y[2] = a[2] ^ b[2] ^ c2;
    assign y[3] = a[3] ^ b[3] ^ c3;
    assign y[4] = a[4] ^ b[4] ^ c4;
    assign y[5] = a[5] ^ b[5] ^ c5;
    assign y[6] = a[6] ^ b[6] ^ c6;
    assign y[7] = a[7] ^ b[7] ^ c7;

    // Final carry-out
    assign Co = g[7] | (p[7] & c7);
endmodule

// Define the module for a 16-bit full adder using two 8-bit adders
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    wire c8;

    adder_8bit adder_low(
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(c8)
    );

    adder_8bit adder_high(
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(c8),
        .y(y[15:8]),
        .Co(Co)
    );
endmodule