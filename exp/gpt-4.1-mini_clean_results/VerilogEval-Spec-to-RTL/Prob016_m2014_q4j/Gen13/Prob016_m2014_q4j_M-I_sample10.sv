module TopModule (
    input  [3:0] x,
    input  [3:0] y,
    output [4:0] sum
);
    wire [3:0] p, g;       // propagate and generate signals
    wire [4:0] carry;      // carry signals including carry-in and carry-out
    assign carry[0] = 1'b0; // initial carry-in

    // Generate propagate and generate signals
    assign p = x ^ y;      // propagate
    assign g = x & y;      // generate

    // Carry lookahead logic for each bit
    assign carry[1] = g[0] | (p[0] & carry[0]);
    assign carry[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & carry[0]);
    assign carry[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & carry[0]);
    assign carry[4] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]) 
                      | (p[3] & p[2] & p[1] & p[0] & carry[0]);

    // Sum bits calculation
    assign sum[3:0] = p ^ carry[3:0];
    assign sum[4] = carry[4];  // overflow bit (final carry out)
endmodule