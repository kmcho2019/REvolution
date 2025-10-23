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

    // Generate and propagate for each bit
    assign g = x & y;
    assign p = x ^ y;

    // Carry-lookahead logic (fully parallel)
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & c[0]);
    assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & c[0]);
    assign c[4] = g[3] 
                  | (p[3] & g[2]) 
                  | (p[3] & p[2] & g[1]) 
                  | (p[3] & p[2] & p[1] & g[0]) 
                  | (p[3] & p[2] & p[1] & p[0] & c[0]);

    // Instantiate full adders with carry-in from carry-lookahead signals
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : FA_CHAIN
            FullAdder fa (
                .a(x[i]),
                .b(y[i]),
                .cin(c[i]),
                .sum(sum[i]),
                .cout()  // cout unused, carry comes from lookahead
            );
        end
    endgenerate

    // Final carry-out is the MSB of sum
    assign sum[4] = c[4];

endmodule