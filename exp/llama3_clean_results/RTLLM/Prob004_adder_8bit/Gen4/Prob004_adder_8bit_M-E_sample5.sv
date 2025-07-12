module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    // Lower 4 bits: Ripple-carry adder
    wire [3:0] sum_lower;
    wire cout_lower;

    full_adder fa0(a[0], b[0], cin, sum_lower[0], cout_lower);
    full_adder fa1(a[1], b[1], cout_lower, sum_lower[1], cout_lower);
    full_adder fa2(a[2], b[2], cout_lower, sum_lower[2], cout_lower);
    full_adder fa3(a[3], b[3], cout_lower, sum_lower[3], cout_lower);

    // Upper 4 bits: Carry-lookahead adder
    wire [3:0] sum_upper;
    wire cout_upper;
    wire [3:0] p, g;
    wire [4:0] c;

    assign p[0] = a[4] ^ b[4];
    assign g[0] = a[4] & b[4];
    assign c[0] = cout_lower;

    assign sum_upper[0] = p[0] ^ c[0];
    assign c[1] = g[0] | (p[0] & c[0]);

    assign p[1] = a[5] ^ b[5];
    assign g[1] = a[5] & b[5];
    assign sum_upper[1] = p[1] ^ c[1];
    assign c[2] = g[1] | (p[1] & c[1]);

    assign p[2] = a[6] ^ b[6];
    assign g[2] = a[6] & b[6];
    assign sum_upper[2] = p[2] ^ c[2];
    assign c[3] = g[2] | (p[2] & c[2]);

    assign p[3] = a[7] ^ b[7];
    assign g[3] = a[7] & b[7];
    assign sum_upper[3] = p[3] ^ c[3];
    assign cout_upper = g[3] | (p[3] & c[3]);

    assign sum[3:0] = sum_lower;
    assign sum[7:4] = sum_upper;
    assign cout = cout_upper;

endmodule

module full_adder(a, b, cin, sum, cout);
    input a, b, cin;
    output sum, cout;

    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);

endmodule