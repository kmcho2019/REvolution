module TopModule(
    input clk,
    input resetn,
    input in,
    output out
);

reg q0, q1, q2, q3;

DFFE dff0 (.Q(q0), .D(in), .CK(clk), .RSTN(resetn));
DFFE dff1 (.Q(q1), .D(q0), .CK(clk), .RSTN(resetn));
DFFE dff2 (.Q(q2), .D(q1), .CK(clk), .RSTN(resetn));
DFFE dff3 (.Q(q3), .D(q2), .CK(clk), .RSTN(resetn));

assign out = q3;

endmodule