module TopModule(
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);

    wire c0, c1, c2, c3;

    // Instantiate full adders for each bit
    full_adder fa0(
        .a(x[0]),
        .b(y[0]),
        .cin(1'b0),  // No carry in for LSB
        .sum(sum[0]),
        .cout(c0)
    );

    full_adder fa1(
        .a(x[1]),
        .b(y[1]),
        .cin(c0),
        .sum(sum[1]),
        .cout(c1)
    );

    full_adder fa2(
        .a(x[2]),
        .b(y[2]),
        .cin(c1),
        .sum(sum[2]),
        .cout(c2)
    );

    full_adder fa3(
        .a(x[3]),
        .b(y[3]),
        .cin(c2),
        .sum(sum[3]),
        .cout(c3)
    );

    // The final carry out becomes sum[4]
    assign sum[4] = c3;

endmodule

// Full adder module definition
module full_adder(
    input a,
    input b,
    input cin,
    output sum,
    output cout
);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule