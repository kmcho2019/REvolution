module TopModule (
    input clk,
    input [7:0] d,
    output [7:0] q
);

    // Instantiate 8 D flip-flops
    FDRE ff0 (.C(clk), .D(d[0]), .Q(q[0]));
    FDRE ff1 (.C(clk), .D(d[1]), .Q(q[1]));
    FDRE ff2 (.C(clk), .D(d[2]), .Q(q[2]));
    FDRE ff3 (.C(clk), .D(d[3]), .Q(q[3]));
    FDRE ff4 (.C(clk), .D(d[4]), .Q(q[4]));
    FDRE ff5 (.C(clk), .D(d[5]), .Q(q[5]));
    FDRE ff6 (.C(clk), .D(d[6]), .Q(q[6]));
    FDRE ff7 (.C(clk), .D(d[7]), .Q(q[7]));

endmodule