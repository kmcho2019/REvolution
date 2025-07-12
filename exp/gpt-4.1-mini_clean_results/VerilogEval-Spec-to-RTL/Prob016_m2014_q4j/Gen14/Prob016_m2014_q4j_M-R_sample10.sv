module TopModule (
    input  [3:0] x,
    input  [3:0] y,
    output [4:0] sum
);
    wire [3:0] g = x & y;          // generate signals
    wire [3:0] p = x ^ y;          // propagate signals
    wire c0 = 1'b0;

    // Compute carries using carry-lookahead logic compactly
    wire c1 = g[0] | (p[0] & c0);
    wire c2 = g[1] | (p[1] & c1);
    wire c3 = g[2] | (p[2] & c2);
    wire c4 = g[3] | (p[3] & c3);

    // Group carries into a vector for easier sum computation
    wire [3:0] c = {c3, c2, c1, c0};

    // sum bits: sum[i] = p[i] ^ c[i]
    assign sum = {c4, p ^ c};

endmodule