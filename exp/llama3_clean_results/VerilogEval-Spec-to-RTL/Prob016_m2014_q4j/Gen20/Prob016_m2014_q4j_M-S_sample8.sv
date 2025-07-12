// Improved FullAdder module with explicit output port definitions
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

// Simplified TopModule using FullAdder instances
module TopModule(
    input   logic [3:0] x,
    input   logic [3:0] y,
    output  logic [4:0] sum
);

    wire logic carry_1, carry_2, carry_3; // Declare carry wires with logic type

    FullAdder fa_0(.a(x[0]), .b(y[0]), .cin(1'b0), .sum(sum[0]), .cout(carry_1));
    FullAdder fa_1(.a(x[1]), .b(y[1]), .cin(carry_1), .sum(sum[1]), .cout(carry_2));
    FullAdder fa_2(.a(x[2]), .b(y[2]), .cin(carry_2), .sum(sum[2]), .cout(carry_3));
    FullAdder fa_3(.a(x[3]), .b(y[3]), .cin(carry_3), .sum(sum[3]), .cout(sum[4]));

endmodule