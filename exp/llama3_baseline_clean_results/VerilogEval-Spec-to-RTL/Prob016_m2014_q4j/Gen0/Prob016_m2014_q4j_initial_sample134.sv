module TopModule(
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);

    // Declare internal wires for carry bits
    wire c1, c2, c3;

    // First full adder (least significant bits)
    full_adder fa0(
       .a(x[0]),
       .b(y[0]),
       .cin(1'b0),
       .cout(c1),
       .sum(sum[0])
    );

    // Second full adder
    full_adder fa1(
       .a(x[1]),
       .b(y[1]),
       .cin(c1),
       .cout(c2),
       .sum(sum[1])
    );

    // Third full adder
    full_adder fa2(
       .a(x[2]),
       .b(y[2]),
       .cin(c2),
       .cout(c3),
       .sum(sum[2])
    );

    // Fourth full adder (most significant bits)
    full_adder fa3(
       .a(x[3]),
       .b(y[3]),
       .cin(c3),
       .cout(sum[4]),
       .sum(sum[3])
    );

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