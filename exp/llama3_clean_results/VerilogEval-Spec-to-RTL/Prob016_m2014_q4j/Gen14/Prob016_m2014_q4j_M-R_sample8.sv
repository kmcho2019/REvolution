// FullAdder module remains the same
module FullAdder(
    input   logic a,
    input   logic b,
    input   logic cin,
    output  logic sum,
    output  logic cout
);

    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);

endmodule

// Define a new module for the 4-bit adder
module FourBitAdder(
    input   logic [3:0] x,
    input   logic [3:0] y,
    output  logic [3:0] sum,
    output  logic cout
);

    logic carry_1, carry_2, carry_3; // Declare carry wires with logic type

    // Instantiate FullAdder modules for each bit position
    FullAdder fa0(
       .a(x[0]),
       .b(y[0]),
       .cin(1'b0),
       .sum(sum[0]),
       .cout(carry_1)
    );

    FullAdder fa1(
       .a(x[1]),
       .b(y[1]),
       .cin(carry_1),
       .sum(sum[1]),
       .cout(carry_2)
    );

    FullAdder fa2(
       .a(x[2]),
       .b(y[2]),
       .cin(carry_2),
       .sum(sum[2]),
       .cout(carry_3)
    );

    FullAdder fa3(
       .a(x[3]),
       .b(y[3]),
       .cin(carry_3),
       .sum(sum[3]),
       .cout(cout)
    );

endmodule

// TopModule instantiates the 4-bit adder module
module TopModule(
    input   logic [3:0] x,
    input   logic [3:0] y,
    output  logic [4:0] sum
);

    logic [3:0] sum_4bit; // Declare a 4-bit wire for the sum
    logic cout; // Declare a wire for the carry out

    // Instantiate the 4-bit adder module
    FourBitAdder fba(
       .x(x),
       .y(y),
       .sum(sum_4bit),
       .cout(cout)
    );

    // Assign the sum and carry out to the output port
    assign sum[3:0] = sum_4bit;
    assign sum[4] = cout;

endmodule