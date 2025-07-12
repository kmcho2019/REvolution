module FullAdder(
    input  a,
    input  b,
    input  cin,
    output sum,
    output cout
);
    wire axb = a ^ b;
    assign sum = axb ^ cin;
    assign cout = (a & b) | (axb & cin);
endmodule

module TopModule(
    input  [3:0] x,
    input  [3:0] y,
    output [4:0] sum
);
    wire [3:0] p; // propagate signals
    wire [3:0] g; // generate signals
    wire [4:0] c; // carry signals

    assign p = x ^ y;
    assign g = x & y;
    assign c[0] = 1'b0;

    // Carry-lookahead logic for 4 bits
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & c[1]);
    assign c[3] = g[2] | (p[2] & c[2]);
    assign c[4] = g[3] | (p[3] & c[3]);

    // Sum bits using propagate and carry-in
    assign sum[3:0] = p ^ c[3:0];
    assign sum[4] = c[4];  // overflow bit
endmodule