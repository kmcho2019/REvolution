module TopModule(
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);

    wire [3:0] carry;  // Carry bits between full adders

    // Instantiate the first full adder (LSB)
    full_adder fa0 (
        .a(x[0]),
        .b(y[0]),
        .cin(1'b0),    // No carry-in for LSB
        .sum(sum[0]),
        .cout(carry[0])
    );

    // Instantiate the second full adder
    full_adder fa1 (
        .a(x[1]),
        .b(y[1]),
        .cin(carry[0]),
        .sum(sum[1]),
        .cout(carry[1])
    );

    // Instantiate the third full adder
    full_adder fa2 (
        .a(x[2]),
        .b(y[2]),
        .cin(carry[1]),
        .sum(sum[2]),
        .cout(carry[2])
    );

    // Instantiate the fourth full adder (MSB)
    full_adder fa3 (
        .a(x[3]),
        .b(y[3]),
        .cin(carry[2]),
        .sum(sum[3]),
        .cout(sum[4])  // Final carry becomes overflow bit
    );

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