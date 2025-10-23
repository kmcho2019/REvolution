// Single-bit full adder with minimal sum and carry logic plus internal propagate and generate signals
module bit_full_adder (
    input  wire a,
    input  wire b,
    input  wire cin,
    output wire sum,
    output wire p,    // propagate = a XOR b
    output wire g     // generate = a AND b
);
    wire axb;
    assign axb = a ^ b;
    assign sum = axb ^ cin;
    assign p   = axb;
    assign g   = a & b;
endmodule

// 8-bit adder module using explicit instantiation of bit_full_adders and carry look-ahead logic
module adder_8bit (
    input  wire [7:0] a,    // operand A
    input  wire [7:0] b,    // operand B
    input  wire       cin,  // carry-in
    output wire [7:0] sum,  // sum output
    output wire       cout  // carry-out
);
    wire [7:0] p, g;        // propagate and generate signals from each full adder
    wire [8:0] c;           // carry signals: c[0] = cin, c[8] = cout

    assign c[0] = cin;

    // Instantiate each bit full adder to generate sum, propagate, and generate signals
    bit_full_adder fa0 (.a(a[0]), .b(b[0]), .cin(c[0]), .sum(sum[0]), .p(p[0]), .g(g[0]));
    bit_full_adder fa1 (.a(a[1]), .b(b[1]), .cin(c[1]), .sum(sum[1]), .p(p[1]), .g(g[1]));
    bit_full_adder fa2 (.a(a[2]), .b(b[2]), .cin(c[2]), .sum(sum[2]), .p(p[2]), .g(g[2]));
    bit_full_adder fa3 (.a(a[3]), .b(b[3]), .cin(c[3]), .sum(sum[3]), .p(p[3]), .g(g[3]));
    bit_full_adder fa4 (.a(a[4]), .b(b[4]), .cin(c[4]), .sum(sum[4]), .p(p[4]), .g(g[4]));
    bit_full_adder fa5 (.a(a[5]), .b(b[5]), .cin(c[5]), .sum(sum[5]), .p(p[5]), .g(g[5]));
    bit_full_adder fa6 (.a(a[6]), .b(b[6]), .cin(c[6]), .sum(sum[6]), .p(p[6]), .g(g[6]));
    bit_full_adder fa7 (.a(a[7]), .b(b[7]), .cin(c[7]), .sum(sum[7]), .p(p[7]), .g(g[7]));

    // Carry look-ahead logic for all carries computed in parallel
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & c[1]);
    assign c[3] = g[2] | (p[2] & c[2]);
    assign c[4] = g[3] | (p[3] & c[3]);
    assign c[5] = g[4] | (p[4] & c[4]);
    assign c[6] = g[5] | (p[5] & c[5]);
    assign c[7] = g[6] | (p[6] & c[6]);
    assign c[8] = g[7] | (p[7] & c[7]);

    assign cout = c[8];
endmodule