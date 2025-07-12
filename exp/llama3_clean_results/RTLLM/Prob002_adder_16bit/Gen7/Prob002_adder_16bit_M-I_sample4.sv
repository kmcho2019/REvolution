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
module adder_4bit(
    input [3:0] a,
    input [3:0] b,
    input Cin,
    output [3:0] y,
    output Co
);

    // Internal signals for generate (G) and propagate (P)
    wire [3:0] G, P;

    // Calculate G and P signals
    assign G[0] = a[0] & b[0];
    assign P[0] = a[0] | b[0];

    assign G[1] = a[1] & b[1];
    assign P[1] = a[1] | b[1];

    assign G[2] = a[2] & b[2];
    assign P[2] = a[2] | b[2];

    assign G[3] = a[3] & b[3];
    assign P[3] = a[3] | b[3];

    // Calculate carry signals
    wire C1, C2, C3;
    assign C1 = G[0] | (P[0] & Cin);
    assign C2 = G[1] | (P[1] & C1);
    assign C3 = G[2] | (P[2] & C2);

    // Instantiate 1-bit adders
    adder_1bit adder_0(
       .a(a[0]),
       .b(b[0]),
       .Cin(Cin),
       .y(y[0]),
       .Co()
    );

    adder_1bit adder_1(
       .a(a[1]),
       .b(b[1]),
       .Cin(C1),
       .y(y[1]),
       .Co()
    );

    adder_1bit adder_2(
       .a(a[2]),
       .b(b[2]),
       .Cin(C2),
       .y(y[2]),
       .Co()
    );

    adder_1bit adder_3(
       .a(a[3]),
       .b(b[3]),
       .Cin(C3),
       .y(y[3]),
       .Co()
    );

    // Assign Co
    assign Co = G[3] | (P[3] & C3);

endmodule

// Define the module for a 16-bit full adder using four 4-bit adders
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);

    // Internal signals for carry
    wire carry_4bit_1, carry_4bit_2, carry_4bit_3;

    // Instantiate the least significant 4-bit adder
    adder_4bit adder_ls(
       .a(a[3:0]),
       .b(b[3:0]),
       .Cin(Cin),
       .y(y[3:0]),
       .Co(carry_4bit_1)
    );

    // Instantiate the second 4-bit adder
    adder_4bit adder_2(
       .a(a[7:4]),
       .b(b[7:4]),
       .Cin(carry_4bit_1),
       .y(y[7:4]),
       .Co(carry_4bit_2)
    );

    // Instantiate the third 4-bit adder
    adder_4bit adder_3(
       .a(a[11:8]),
       .b(b[11:8]),
       .Cin(carry_4bit_2),
       .y(y[11:8]),
       .Co(carry_4bit_3)
    );

    // Instantiate the most significant 4-bit adder
    adder_4bit adder_ms(
       .a(a[15:12]),
       .b(b[15:12]),
       .Cin(carry_4bit_3),
       .y(y[15:12]),
       .Co(Co)
    );

endmodule