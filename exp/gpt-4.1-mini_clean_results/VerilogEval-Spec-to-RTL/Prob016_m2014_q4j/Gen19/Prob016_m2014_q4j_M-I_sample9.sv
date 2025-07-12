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
    wire [3:0] g = x & y;      // Generate signals
    wire [3:0] p = x ^ y;      // Propagate signals
    wire c0 = 1'b0;            // Initial carry-in

    // Full carry-lookahead logic (parallel carry computation)
    wire c1 = g[0] | (p[0] & c0);
    wire c2 = g[1] | (p[1] & g[0]) | (p[1] & p[0] & c0);
    wire c3 = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & c0);
    wire c4 = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]) | (p[3] & p[2] & p[1] & p[0] & c0);

    wire [4:0] c = {c4, c3, c2, c1, c0};

    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : FA_LOOP
            FullAdder fa (
                .a(x[i]),
                .b(y[i]),
                .cin(c[i]),
                .sum(sum[i]),
                .cout()  // Unconnected carry-out; no extra wires to save area
            );
        end
    endgenerate

    assign sum[4] = c4; // Final carry-out as MSB overflow bit
endmodule