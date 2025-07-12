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

// Improved TopModule with better naming conventions and explicit port widths
module TopModule(
    input   logic [3:0] x,
    input   logic [3:0] y,
    output  logic [4:0] sum
);

    wire logic carry_1, carry_2, carry_3; // Declare carry wires with logic type

    assign sum[0] = x[0] ^ y[0] ^ 1'b0;
    assign carry_1 = (x[0] & y[0]) | (x[0] & 1'b0) | (y[0] & 1'b0);

    assign sum[1] = x[1] ^ y[1] ^ carry_1;
    assign carry_2 = (x[1] & y[1]) | (x[1] & carry_1) | (y[1] & carry_1);

    assign sum[2] = x[2] ^ y[2] ^ carry_2;
    assign carry_3 = (x[2] & y[2]) | (x[2] & carry_2) | (y[2] & carry_2);

    assign sum[3] = x[3] ^ y[3] ^ carry_3;
    assign sum[4] = (x[3] & y[3]) | (x[3] & carry_3) | (y[3] & carry_3);

endmodule