module DFF_AR (
    input clk,
    input areset,
    input en,
    input d,
    output reg q
);

always @(posedge clk or posedge areset) begin
    if (areset) begin
        q <= 1'b0;
    end
    else if (en) begin
        q <= d;
    end
end

endmodule

module TopModule (
    input clk,
    input areset,
    input [7:0] d,
    output [7:0] q
);

// Stability detector for clock gating
reg [7:0] prev_d;
wire stable = (prev_d == d);
always @(posedge clk or posedge areset) begin
    if (areset) prev_d <= 8'b0;
    else prev_d <= d;
end

// Direct instantiation of 8 DFFs for better area optimization
DFF_AR dff0 (.clk(clk), .areset(areset), .en(~stable), .d(d[0]), .q(q[0]));
DFF_AR dff1 (.clk(clk), .areset(areset), .en(~stable), .d(d[1]), .q(q[1]));
DFF_AR dff2 (.clk(clk), .areset(areset), .en(~stable), .d(d[2]), .q(q[2]));
DFF_AR dff3 (.clk(clk), .areset(areset), .en(~stable), .d(d[3]), .q(q[3]));
DFF_AR dff4 (.clk(clk), .areset(areset), .en(~stable), .d(d[4]), .q(q[4]));
DFF_AR dff5 (.clk(clk), .areset(areset), .en(~stable), .d(d[5]), .q(q[5]));
DFF_AR dff6 (.clk(clk), .areset(areset), .en(~stable), .d(d[6]), .q(q[6]));
DFF_AR dff7 (.clk(clk), .areset(areset), .en(~stable), .d(d[7]), .q(q[7]));

endmodule