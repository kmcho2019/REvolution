// Define the module for a full adder
module full_adder(
    input a,
    input b,
    input Cin,
    output sum,
    output Cout
);

    assign sum = a ^ b ^ Cin;
    assign Cout = (a & b) | (a & Cin) | (b & Cin);

endmodule

// Define the module for an 8-bit adder
module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);

    wire [7:0] carry;

    // First bit (bit 0) adder
    full_adder adder_0(
        .a(a[0]),
        .b(b[0]),
        .Cin(Cin),
        .sum(y[0]),
        .Cout(carry[0])
    );

    // Bits 1 to 7 adders
    full_adder adder_1(
        .a(a[1]),
        .b(b[1]),
        .Cin(carry[0]),
        .sum(y[1]),
        .Cout(carry[1])
    );

    full_adder adder_2(
        .a(a[2]),
        .b(b[2]),
        .Cin(carry[1]),
        .sum(y[2]),
        .Cout(carry[2])
    );

    full_adder adder_3(
        .a(a[3]),
        .b(b[3]),
        .Cin(carry[2]),
        .sum(y[3]),
        .Cout(carry[3])
    );

    full_adder adder_4(
        .a(a[4]),
        .b(b[4]),
        .Cin(carry[3]),
        .sum(y[4]),
        .Cout(carry[4])
    );

    full_adder adder_5(
        .a(a[5]),
        .b(b[5]),
        .Cin(carry[4]),
        .sum(y[5]),
        .Cout(carry[5])
    );

    full_adder adder_6(
        .a(a[6]),
        .b(b[6]),
        .Cin(carry[5]),
        .sum(y[6]),
        .Cout(carry[6])
    );

    full_adder adder_7(
        .a(a[7]),
        .b(b[7]),
        .Cin(carry[6]),
        .sum(y[7]),
        .Cout(Co)
    );

endmodule

// Define the module for a 16-bit adder
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