module TopModule (
    input clk,
    input [7:0] d,
    output [7:0] q
);

    // Instantiate 8 D flip-flops (FDRE is a basic DFF with clock enable)
    FDRE dff0 (.C(clk), .CE(1'b1), .D(d[0]), .Q(q[0]));
    FDRE dff1 (.C(clk), .CE(1'b1), .D(d[1]), .Q(q[1]));
    FDRE dff2 (.C(clk), .CE(1'b1), .D(d[2]), .Q(q[2]));
    FDRE dff3 (.C(clk), .CE(1'b1), .D(d[3]), .Q(q[3]));
    FDRE dff4 (.C(clk), .CE(1'b1), .D(d[4]), .Q(q[4]));
    FDRE dff5 (.C(clk), .CE(1'b1), .D(d[5]), .Q(q[5]));
    FDRE dff6 (.C(clk), .CE(1'b1), .D(d[6]), .Q(q[6]));
    FDRE dff7 (.C(clk), .CE(1'b1), .D(d[7]), .Q(q[7]));

endmodule