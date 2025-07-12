module FullAdder(
    input   a,
    input   b,
    input   cin,
    output  sum,
    output  cout
);

    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);

endmodule

module TopModule(
    input   [3:0] x,
    input   [3:0] y,
    output  [4:0] sum
);

    wire [2:0] p;
    wire [2:0] g;
    wire [3:0] c;

    assign p[0] = x[0] ^ y[0];
    assign g[0] = x[0] & y[0];
    assign c[0] = 1'b0;
    assign sum[0] = p[0] ^ c[0];

    assign p[1] = x[1] ^ y[1];
    assign g[1] = x[1] & y[1];
    assign c[1] = g[0] | (p[0] & c[0]);
    assign sum[1] = p[1] ^ c[1];

    assign p[2] = x[2] ^ y[2];
    assign g[2] = x[2] & y[2];
    assign c[2] = g[1] | (p[1] & c[1]);
    assign sum[2] = p[2] ^ c[2];

    assign c[3] = g[2] | (p[2] & c[2]);
    assign sum[3] = x[3] ^ y[3] ^ c[3];
    assign sum[4] = c[3];

endmodule