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
    wire [3:0] g;     // generate signals
    wire [3:0] p;     // propagate signals
    wire [4:0] c;     // carry signals: c[0] = 0 initial carry-in

    assign c[0] = 1'b0;

    // Generate and propagate signals for each bit
    assign g = x & y;
    assign p = x ^ y;

    // Fully parallel carry-lookahead logic:
    // c[1] = g0 + p0*c0
    // c[2] = g1 + p1*g0 + p1*p0*c0
    // c[3] = g2 + p2*g1 + p2*p1*g0 + p2*p1*p0*c0
    // c[4] = g3 + p3*g2 + p3*p2*g1 + p3*p2*p1*g0 + p3*p2*p1*p0*c0
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & c[0]);
    assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & c[0]);
    assign c[4] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]) | (p[3] & p[2] & p[1] & p[0] & c[0]);

    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : fa_chain
            FullAdder fa (
                .a(x[i]),
                .b(y[i]),
                .cin(c[i]),
                .sum(sum[i]),
                .cout() // unused carry-out to avoid redundant toggling
            );
        end
    endgenerate

    assign sum[4] = c[4];  // final carry-out as overflow bit

endmodule