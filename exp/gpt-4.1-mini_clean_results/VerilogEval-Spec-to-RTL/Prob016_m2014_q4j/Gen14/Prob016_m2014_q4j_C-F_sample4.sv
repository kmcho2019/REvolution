module FullAdder (
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

module TopModule (
    input  [3:0] x,
    input  [3:0] y,
    output [4:0] sum
);
    wire [3:0] g, p;        // generate and propagate
    wire [4:0] c;           // carry signals: c[0] = 0 (initial carry-in)

    assign c[0] = 1'b0;

    // Generate and propagate signals
    assign g = x & y;
    assign p = x ^ y;

    // Carry-lookahead logic: compute carry signals in parallel
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & c[1]);
    assign c[3] = g[2] | (p[2] & c[2]);
    assign c[4] = g[3] | (p[3] & c[3]);

    // Instantiate FullAdders in a generate loop with carry-in signals from carry-lookahead logic
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : adder_chain
            FullAdder fa (
                .a(x[i]),
                .b(y[i]),
                .cin(c[i]),
                .sum(sum[i]),
                .cout() // cout unused here, carry is computed separately
            );
        end
    endgenerate

    // Assign final carry-out as the MSB (overflow) bit of sum
    assign sum[4] = c[4];

endmodule