// Define a half adder module
module half_adder(
    input  a,
    input  b,
    output sum,
    output cout
);
    assign sum = a ^ b;
    assign cout = a & b;
endmodule

// Define a parallel prefix adder module
module parallel_prefix_adder(
    input  [3:0] x,
    input  [3:0] y,
    output [4:0] sum
);

// Initialize wires for prefix sums and carries
wire p0, p1, p2, p3; // prefix sums
wire g0, g1, g2, g3; // prefix carries
wire c0, c1, c2, c3; // internal carries

// Compute prefix sums and carries
half_adder ha0(x[0], y[0], p0, g0);
half_adder ha1(x[1], y[1], p1, g1);
half_adder ha2(x[2], y[2], p2, g2);
half_adder ha3(x[3], y[3], p3, g3);

// Compute internal carries using prefix sums and carries
assign c0 = g0;
assign c1 = g0 | g1;
assign c2 = g0 | g1 | g2;
assign c3 = g0 | g1 | g2 | g3;

// Compute final sum bits using prefix sums and internal carries
assign sum[0] = p0;
assign sum[1] = p1 ^ c0;
assign sum[2] = p2 ^ c1;
assign sum[3] = p3 ^ c2;
assign sum[4] = c3;

endmodule

// TopModule that instantiates the parallel prefix adder
module TopModule(
    input  [3:0] x,
    input  [3:0] y,
    output [4:0] sum
);
    parallel_prefix_adder ppa(x, y, sum);
endmodule