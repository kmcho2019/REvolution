// Define the 8-bit full adder module
module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);

    wire [7:0] temp;
    assign temp = a + b;
    assign y = temp + Cin;
    assign Co = (a[7] & b[7] & Cin) | (a[7] & temp[7]) | (b[7] & temp[7]);

endmodule

// Define the 16-bit full adder module
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);

    wire Co_8bit;
    wire [7:0] lower_a, lower_b, lower_y;
    wire [7:0] upper_a, upper_b, upper_y;

    assign lower_a = a[7:0];
    assign lower_b = b[7:0];
    assign upper_a = a[15:8];
    assign upper_b = b[15:8];

    // Instantiate the 8-bit adder for lower 8 bits
    adder_8bit u1(
        .a(lower_a),
        .b(lower_b),
        .Cin(Cin),
        .y(lower_y),
        .Co(Co_8bit)
    );

    // Instantiate the 8-bit adder for upper 8 bits
    adder_8bit u2(
        .a(upper_a),
        .b(upper_b),
        .Cin(Co_8bit),
        .y(upper_y),
        .Co(Co)
    );

    // Concatenate the results
    assign y = {upper_y, lower_y};

endmodule