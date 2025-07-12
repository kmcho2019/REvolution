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

// Define the module for a 4-bit carry-lookahead adder
module adder_4bit_cla(
    input [3:0] a,
    input [3:0] b,
    input Cin,
    output [3:0] y,
    output Co
);

    wire [3:0] g, p;
    wire C1, C2, C3;

    // Calculate generate (g) and propagate (p) signals
    assign g[0] = a[0] & b[0];
    assign p[0] = a[0] ^ b[0];
    assign g[1] = a[1] & b[1];
    assign p[1] = a[1] ^ b[1];
    assign g[2] = a[2] & b[2];
    assign p[2] = a[2] ^ b[2];
    assign g[3] = a[3] & b[3];
    assign p[3] = a[3] ^ b[3];

    // Calculate carry signals
    assign C1 = g[0] | (p[0] & Cin);
    assign C2 = g[1] | (p[1] & C1);
    assign C3 = g[2] | (p[2] & C2);
    assign Co = g[3] | (p[3] & C3);

    // Calculate sum signals
    assign y[0] = p[0] ^ Cin;
    assign y[1] = p[1] ^ C1;
    assign y[2] = p[2] ^ C2;
    assign y[3] = p[3] ^ C3;

endmodule

// Define the module for an 8-bit carry-lookahead adder
module adder_8bit_cla(
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);

    wire C4;

    // Instantiate two 4-bit carry-lookahead adders
    adder_4bit_cla adder_ls(
        .a(a[3:0]),
        .b(b[3:0]),
        .Cin(Cin),
        .y(y[3:0]),
        .Co(C4)
    );

    adder_4bit_cla adder_ms(
        .a(a[7:4]),
        .b(b[7:4]),
        .Cin(C4),
        .y(y[7:4]),
        .Co(Co)
    );

endmodule

// Define the module for a 16-bit carry-lookahead adder
module adder_16bit_cla(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);

    wire C8;

    // Instantiate two 8-bit carry-lookahead adders
    adder_8bit_cla adder_lower(
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(C8)
    );

    adder_8bit_cla adder_upper(
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(C8),
        .y(y[15:8]),
        .Co(Co)
    );

endmodule