// Improved FullAdder module (remains the same as the original)
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

// Improved TopModule with carry-lookahead adder
module TopModule(
    input   logic [3:0] x,
    input   logic [3:0] y,
    output  logic [4:0] sum
);

    wire logic p0, p1, p2, p3; // Generate signals
    wire logic g0, g1, g2, g3; // Propagate signals
    wire logic c0, c1, c2, c3; // Carry signals

    // Calculate generate and propagate signals
    assign p0 = x[0] ^ y[0];
    assign g0 = x[0] & y[0];
    assign p1 = x[1] ^ y[1];
    assign g1 = x[1] & y[1];
    assign p2 = x[2] ^ y[2];
    assign g2 = x[2] & y[2];
    assign p3 = x[3] ^ y[3];
    assign g3 = x[3] & y[3];

    // Calculate carry signals using carry-lookahead
    assign c0 = g0;
    assign c1 = g0 & p1 | g1;
    assign c2 = g0 & p1 & p2 | g1 & p2 | g2;
    assign c3 = g0 & p1 & p2 & p3 | g1 & p2 & p3 | g2 & p3 | g3;

    // Calculate sum signals
    assign sum[0] = p0;
    assign sum[1] = p1 ^ c0;
    assign sum[2] = p2 ^ c1;
    assign sum[3] = p3 ^ c2;
    assign sum[4] = c3;

endmodule