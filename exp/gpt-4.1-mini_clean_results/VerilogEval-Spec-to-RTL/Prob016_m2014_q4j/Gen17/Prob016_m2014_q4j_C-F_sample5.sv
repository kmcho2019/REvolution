module FullAdder(
    input  a,
    input  b,
    input  cin,
    output sum,
    output cout
);
    // FullAdder computes sum and carry-out.
    // In this design, cout is not used externally to avoid redundant toggling,
    // but we keep it for completeness and potential reuse.
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

    // Carry-lookahead logic: compute carries in parallel to reduce delay
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & c[1]);
    assign c[3] = g[2] | (p[2] & c[2]);
    assign c[4] = g[3] | (p[3] & c[3]);

    // Instantiate four FullAdder modules using generate loop,
    // feeding carry-in from carry-lookahead logic and ignoring cout to save power.
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

    // Assign the final carry-out as the MSB (overflow) of sum
    assign sum[4] = c[4];

endmodule