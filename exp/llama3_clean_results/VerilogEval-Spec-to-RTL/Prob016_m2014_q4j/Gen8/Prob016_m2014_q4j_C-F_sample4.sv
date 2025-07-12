// Improved FullAdder module with concise logic and improved naming conventions
module FullAdder(
    input   logic a,
    input   logic b,
    input   logic cin,
    output  logic sum,
    output  logic cout
);
    // Using the XOR and OR operators to calculate sum and carry
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

// Improved TopModule with better formatting and naming conventions
module TopModule(
    input   logic [3:0] x,
    input   logic [3:0] y,
    output  logic [4:0] sum
);
    // Declare wires for carry signals with descriptive names
    logic carry_bit_1, carry_bit_2, carry_bit_3;

    // Instantiate FullAdder modules for each bit with improved naming conventions
    FullAdder fa_bit_0(
        .a(x[0]),
        .b(y[0]),
        .cin(1'b0),
        .sum(sum[0]),
        .cout(carry_bit_1)
    );

    FullAdder fa_bit_1(
        .a(x[1]),
        .b(y[1]),
        .cin(carry_bit_1),
        .sum(sum[1]),
        .cout(carry_bit_2)
    );

    FullAdder fa_bit_2(
        .a(x[2]),
        .b(y[2]),
        .cin(carry_bit_2),
        .sum(sum[2]),
        .cout(carry_bit_3)
    );

    FullAdder fa_bit_3(
        .a(x[3]),
        .b(y[3]),
        .cin(carry_bit_3),
        .sum(sum[3]),
        .cout(sum[4]) // The final carry-out is the overflow bit
    );
endmodule