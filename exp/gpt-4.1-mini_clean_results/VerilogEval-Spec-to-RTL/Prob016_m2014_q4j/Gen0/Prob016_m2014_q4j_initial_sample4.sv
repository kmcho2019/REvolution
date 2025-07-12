module FullAdder(
    input a,
    input b,
    input cin,
    output sum,
    output cout
);
    assign {cout, sum} = a + b + cin;
endmodule

module TopModule(
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);
    wire c1, c2, c3, c4;

    // First bit addition
    FullAdder fa0(.a(x[0]), .b(y[0]), .cin(1'b0), .sum(sum[0]), .cout(c1));
    // Second bit addition
    FullAdder fa1(.a(x[1]), .b(y[1]), .cin(c1), .sum(sum[1]), .cout(c2));
    // Third bit addition
    FullAdder fa2(.a(x[2]), .b(y[2]), .cin(c2), .sum(sum[2]), .cout(c3));
    // Fourth bit addition
    FullAdder fa3(.a(x[3]), .b(y[3]), .cin(c3), .sum(sum[3]), .cout(c4));

    // Overflow bit
    assign sum[4] = c4;

endmodule