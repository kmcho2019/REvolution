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
    wire c1, c2, c3;

    // Instantiate FullAdder modules for each bit
    FullAdder fa0(
        .a(x[0]),
        .b(y[0]),
        .cin(1'b0),
        .sum(sum[0]),
        .cout(c1)
    );

    FullAdder fa1(
        .a(x[1]),
        .b(y[1]),
        .cin(c1),
        .sum(sum[1]),
        .cout(c2)
    );

    FullAdder fa2(
        .a(x[2]),
        .b(y[2]),
        .cin(c2),
        .sum(sum[2]),
        .cout(c3)
    );

    FullAdder fa3(
        .a(x[3]),
        .b(y[3]),
        .cin(c3),
        .sum(sum[3]),
        .cout(sum[4]) // The final carry-out is the overflow bit
    );

endmodule