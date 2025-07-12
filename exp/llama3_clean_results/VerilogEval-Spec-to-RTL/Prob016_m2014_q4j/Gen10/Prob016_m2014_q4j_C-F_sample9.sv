// Define the FullAdder module
module FullAdder(
    input   a,
    input   b,
    input   cin,
    output  sum,
    output  cout
);

    // Use XOR and OR operators to calculate sum and carry
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);

endmodule

// Define the TopModule
module TopModule(
    input   [3:0] x,
    input   [3:0] y,
    output  [4:0] sum
);

    // Declare wires for carry signals
    wire [2:0] carry;

    // Instantiate FullAdder modules for each bit
    FullAdder fa0(
       .a(x[0]),
       .b(y[0]),
       .cin(1'b0),
       .sum(sum[0]),
       .cout(carry[0])
    );

    FullAdder fa1(
       .a(x[1]),
       .b(y[1]),
       .cin(carry[0]),
       .sum(sum[1]),
       .cout(carry[1])
    );

    FullAdder fa2(
       .a(x[2]),
       .b(y[2]),
       .cin(carry[1]),
       .sum(sum[2]),
       .cout(carry[2])
    );

    FullAdder fa3(
       .a(x[3]),
       .b(y[3]),
       .cin(carry[2]),
       .sum(sum[3]),
       .cout(sum[4]) // The final carry-out is the overflow bit
    );

endmodule