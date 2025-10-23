module TopModule(
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);

    wire c0, c1, c2, c3;

    // First full adder (bit 0)
    full_adder fa0(
        .a(x[0]),
        .b(y[0]),
        .cin(1'b0),
        .cout(c0),
        .sum(sum[0])
    );

    // Second full adder (bit 1)
    full_adder fa1(
        .a(x[1]),
        .b(y[1]),
        .cin(c0),
        .cout(c1),
        .sum(sum[1])
    );

    // Third full adder (bit 2)
    full_adder fa2(
        .a(x[2]),
        .b(y[2]),
        .cin(c1),
        .cout(c2),
        .sum(sum[2])
    );

    // Fourth full adder (bit 3)
    full_adder fa3(
        .a(x[3]),
        .b(y[3]),
        .cin(c2),
        .cout(c3),
        .sum(sum[3])
    );

    // Overflow bit
    assign sum[4] = c3;

endmodule

// Full adder module
module full_adder(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);

    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);

endmodule