module TopModule(
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);

    wire [3:0] c;  // Carry wires between full adders

    // Full adder for bit 0
    full_adder fa0(
        .a(x[0]),
        .b(y[0]),
        .cin(1'b0),
        .sum(sum[0]),
        .cout(c[0])
    );

    // Full adder for bit 1
    full_adder fa1(
        .a(x[1]),
        .b(y[1]),
        .cin(c[0]),
        .sum(sum[1]),
        .cout(c[1])
    );

    // Full adder for bit 2
    full_adder fa2(
        .a(x[2]),
        .b(y[2]),
        .cin(c[1]),
        .sum(sum[2]),
        .cout(c[2])
    );

    // Full adder for bit 3
    full_adder fa3(
        .a(x[3]),
        .b(y[3]),
        .cin(c[2]),
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