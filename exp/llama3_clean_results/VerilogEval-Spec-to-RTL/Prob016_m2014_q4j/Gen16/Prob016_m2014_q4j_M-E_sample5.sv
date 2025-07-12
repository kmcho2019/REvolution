// Hybrid Adder Module
module HybridAdder(x, y, sum);
    input [3:0] x;
    input [3:0] y;
    output [4:0] sum;

    // Dynamic switching signals
    wire [3:0] switch;

    // Generate switching signals based on input data
    assign switch[0] = x[0] & y[0];
    assign switch[1] = x[1] & y[1];
    assign switch[2] = x[2] & y[2];
    assign switch[3] = x[3] & y[3];

    // Ripple-carry adder modules
    wire [3:0] rc_sum;
    wire [3:0] rc_cout;
    RippleCarryAdder rc_adder(x, y, rc_sum, rc_cout);

    // Carry-lookahead adder modules
    wire [3:0] cla_sum;
    wire [3:0] cla_cout;
    CarryLookaheadAdder cla_adder(x, y, cla_sum, cla_cout);

    // Dynamic switching logic
    assign sum[0] = switch[0]? cla_sum[0] : rc_sum[0];
    assign sum[1] = switch[1]? cla_sum[1] : rc_sum[1];
    assign sum[2] = switch[2]? cla_sum[2] : rc_sum[2];
    assign sum[3] = switch[3]? cla_sum[3] : rc_sum[3];
    assign sum[4] = switch[3]? cla_cout[3] : rc_cout[3];
endmodule

// Ripple-carry adder module
module RippleCarryAdder(x, y, sum, cout);
    input [3:0] x;
    input [3:0] y;
    output [3:0] sum;
    output [3:0] cout;

    // Full adder modules
    wire [3:0] fa_sum;
    wire [3:0] fa_cout;
    FullAdder fa0(x[0], y[0], 1'b0, fa_sum[0], fa_cout[0]);
    FullAdder fa1(x[1], y[1], fa_cout[0], fa_sum[1], fa_cout[1]);
    FullAdder fa2(x[2], y[2], fa_cout[1], fa_sum[2], fa_cout[2]);
    FullAdder fa3(x[3], y[3], fa_cout[2], fa_sum[3], fa_cout[3]);

    // Assign sum and cout
    assign sum = fa_sum;
    assign cout = fa_cout;
endmodule

// Carry-lookahead adder module
module CarryLookaheadAdder(x, y, sum, cout);
    input [3:0] x;
    input [3:0] y;
    output [3:0] sum;
    output [3:0] cout;

    // Generate and propagate signals
    wire [3:0] g;
    wire [3:0] p;

    // Calculate generate and propagate signals
    assign g[0] = x[0] & y[0];
    assign g[1] = x[1] & y[1];
    assign g[2] = x[2] & y[2];
    assign g[3] = x[3] & y[3];
    assign p[0] = x[0] ^ y[0];
    assign p[1] = x[1] ^ y[1];
    assign p[2] = x[2] ^ y[2];
    assign p[3] = x[3] ^ y[3];

    // Calculate carry signals
    wire c1, c2, c3, c4;
    assign c1 = g[0] | (p[0] & 1'b0);
    assign c2 = g[1] | (p[1] & c1);
    assign c3 = g[2] | (p[2] & c2);
    assign c4 = g[3] | (p[3] & c3);

    // Calculate sum bits
    assign sum[0] = p[0] ^ 1'b0;
    assign sum[1] = p[1] ^ c1;
    assign sum[2] = p[2] ^ c2;
    assign sum[3] = p[3] ^ c3;
    assign cout[3] = c4;
endmodule

// Full adder module
module FullAdder(a, b, cin, sum, cout);
    input a;
    input b;
    input cin;
    output sum;
    output cout;

    // Calculate sum and carry-out
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule