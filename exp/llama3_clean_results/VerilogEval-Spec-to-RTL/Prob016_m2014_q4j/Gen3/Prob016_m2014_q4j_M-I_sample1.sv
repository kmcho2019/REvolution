module TopModule(
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);

// Calculate generate and propagate signals for each bit position
wire g0, g1, g2, g3;
wire p0, p1, p2, p3;

assign g0 = x[0] & y[0];
assign p0 = x[0] | y[0];

assign g1 = x[1] & y[1];
assign p1 = x[1] | y[1];

assign g2 = x[2] & y[2];
assign p2 = x[2] | y[2];

assign g3 = x[3] & y[3];
assign p3 = x[3] | y[3];

// Calculate carry signals using carry-lookahead logic
wire c1, c2, c3;
assign c1 = g0;
assign c2 = g1 | (p1 & c1);
assign c3 = g2 | (p2 & c2);

// Calculate sum bits using propagate and generate signals
assign sum[0] = p0;
assign sum[1] = p1 ^ c1;
assign sum[2] = p2 ^ c2;
assign sum[3] = p3 ^ c3;

// Calculate overflow bit (carry-out)
assign sum[4] = g3 | (p3 & c3);

endmodule