module FullAdder(
    input a,
    input b,
    input cin,
    output sum,
    output cout
);
    // Optimal full adder implementation
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

module TopModule(
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);
    wire [2:0] carry;  // carry[0]: bit0->bit1, carry[1]: bit1->bit2, carry[2]: bit2->bit3

    // Bit 0 (LSB) - no carry in
    FullAdder fa0 (
        .a(x[0]),
        .b(y[0]),
        .cin(1'b0),
        .sum(sum[0]),
        .cout(carry[0])
    );

    // Bit 1
    FullAdder fa1 (
        .a(x[1]),
        .b(y[1]),
        .cin(carry[0]),
        .sum(sum[1]),
        .cout(carry[1])
    );

    // Bit 2
    FullAdder fa2 (
        .a(x[2]),
        .b(y[2]),
        .cin(carry[1]),
        .sum(sum[2]),
        .cout(carry[2])
    );

    // Bit 3 (MSB) - carry out becomes overflow bit (sum[4])
    FullAdder fa3 (
        .a(x[3]),
        .b(y[3]),
        .cin(carry[2]),
        .sum(sum[3]),
        .cout(sum[4])
    );
endmodule