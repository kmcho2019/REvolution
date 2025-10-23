module TopModule (
    input clk,
    input areset,
    input [7:0] d,
    output [7:0] q
);

// Invert the reset since fdpe has active-high preset (we want reset to set Q=0)
wire reset_n = ~areset;

// Instantiate 8 DFF primitives
fdpe dff0 (.C(clk), .D(d[0]), .PRE(areset), .Q(q[0]));
fdpe dff1 (.C(clk), .D(d[1]), .PRE(areset), .Q(q[1]));
fdpe dff2 (.C(clk), .D(d[2]), .PRE(areset), .Q(q[2]));
fdpe dff3 (.C(clk), .D(d[3]), .PRE(areset), .Q(q[3]));
fdpe dff4 (.C(clk), .D(d[4]), .PRE(areset), .Q(q[4]));
fdpe dff5 (.C(clk), .D(d[5]), .PRE(areset), .Q(q[5]));
fdpe dff6 (.C(clk), .D(d[6]), .PRE(areset), .Q(q[6]));
fdpe dff7 (.C(clk), .D(d[7]), .PRE(areset), .Q(q[7]));

endmodule