// Define the module for a 4-bit full adder using carry-lookahead
module adder_4bit_cla(
    input [3:0] a,
    input [3:0] b,
    input Cin,
    output [3:0] y,
    output Co
);

    // Internal signals for generate and propagate
    wire [3:0] g, p;

    // Calculate generate and propagate signals
    assign g[0] = a[0] & b[0];
    assign p[0] = a[0] | b[0];
    assign g[1] = a[1] & b[1];
    assign p[1] = a[1] | b[1];
    assign g[2] = a[2] & b[2];
    assign p[2] = a[2] | b[2];
    assign g[3] = a[3] & b[3];
    assign p[3] = a[3] | b[3];

    // Calculate sum bits
    assign y[0] = a[0] ^ b[0] ^ Cin;
    assign y[1] = a[1] ^ b[1] ^ (g[0] | (p[0] & Cin));
    assign y[2] = a[2] ^ b[2] ^ (g[1] | (p[1] & (g[0] | (p[0] & Cin))));
    assign y[3] = a[3] ^ b[3] ^ (g[2] | (p[2] & (g[1] | (p[1] & (g[0] | (p[0] & Cin)))));

    // Calculate carry bits
    assign Co = g[3] | (p[3] & (g[2] | (p[2] & (g[1] | (p[1] & (g[0] | (p[0] & Cin))))));

endmodule

// Define the module for an 8-bit full adder using two 4-bit adders
module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);

    wire C1;

    // Instantiate two 4-bit adders
    adder_4bit_cla adder_ls(
        .a(a[3:0]),
        .b(b[3:0]),
        .Cin(Cin),
        .y(y[3:0]),
        .Co(C1)
    );

    adder_4bit_cla adder_ms(
        .a(a[7:4]),
        .b(b[7:4]),
        .Cin(C1),
        .y(y[7:4]),
        .Co(Co)
    );

endmodule

// Define the module for a 16-bit full adder using two 8-bit adders
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);

    wire C1;

    // Instantiate two 8-bit adders
    adder_8bit adder_lower(
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(C1)
    );

    adder_8bit adder_upper(
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(C1),
        .y(y[15:8]),
        .Co(Co)
    );

endmodule