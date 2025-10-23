// Define the module for a 4-bit full adder using carry-lookahead
module adder_4bit(
    input [3:0] a,
    input [3:0] b,
    input Cin,
    output [3:0] y,
    output Co
);

    // Internal signals for generate and propagate
    wire [3:0] g, p;
    wire [4:0] c;

    // Calculate generate and propagate signals
    assign g[0] = a[0] & b[0];
    assign p[0] = a[0] ^ b[0];
    assign c[0] = Cin;

    generate
        for (genvar i = 1; i < 4; i++) begin
            assign g[i] = a[i] & b[i];
            assign p[i] = a[i] ^ b[i];
            assign c[i] = g[i-1] | (p[i-1] & c[i-1]);
        end
    endgenerate

    // Calculate output and final carry
    assign y[0] = p[0] ^ c[0];
    generate
        for (genvar i = 1; i < 4; i++) begin
            assign y[i] = p[i] ^ c[i];
        end
    endgenerate
    assign c[4] = g[3] | (p[3] & c[3]);
    assign Co = c[4];

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