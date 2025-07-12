// Define the module for a 2-bit full adder
module adder_2bit(
    input [1:0] a,
    input [1:0] b,
    input Cin,
    output [1:0] y,
    output Co
);

    // Internal signals for sum and carry
    wire sum0, sum1, carry0, carry1;

    // Bit 0 adder
    assign sum0 = a[0] ^ b[0] ^ Cin;
    assign carry0 = (a[0] & b[0]) | (a[0] & Cin) | (b[0] & Cin);

    // Bit 1 adder
    assign sum1 = a[1] ^ b[1] ^ carry0;
    assign carry1 = (a[1] & b[1]) | (a[1] & carry0) | (b[1] & carry0);

    // Assign outputs
    assign y[0] = sum0;
    assign y[1] = sum1;
    assign Co = carry1;

endmodule

// Define the module for a 4-bit full adder using two 2-bit adders
module adder_4bit_tree(
    input [3:0] a,
    input [3:0] b,
    input Cin,
    output [3:0] y,
    output Co
);

    wire C1;

    // Instantiate two 2-bit adders
    adder_2bit adder_ls(
        .a(a[1:0]),
        .b(b[1:0]),
        .Cin(Cin),
        .y(y[1:0]),
        .Co(C1)
    );

    adder_2bit adder_ms(
        .a(a[3:2]),
        .b(b[3:2]),
        .Cin(C1),
        .y(y[3:2]),
        .Co(Co)
    );

endmodule

// Define the module for an 8-bit full adder using two 4-bit adders
module adder_8bit_tree(
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);

    wire C1;

    // Instantiate two 4-bit adders
    adder_4bit_tree adder_lower(
        .a(a[3:0]),
        .b(b[3:0]),
        .Cin(Cin),
        .y(y[3:0]),
        .Co(C1)
    );

    adder_4bit_tree adder_upper(
        .a(a[7:4]),
        .b(b[7:4]),
        .Cin(C1),
        .y(y[7:4]),
        .Co(Co)
    );

endmodule

// Define the module for a 16-bit full adder using two 8-bit adders
module adder_16bit_tree(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);

    wire C1;

    // Instantiate two 8-bit adders
    adder_8bit_tree adder_lower(
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(C1)
    );

    adder_8bit_tree adder_upper(
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(C1),
        .y(y[15:8]),
        .Co(Co)
    );

endmodule