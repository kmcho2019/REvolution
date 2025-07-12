module TopModule (
    input        clk,
    input        areset,
    input        load,
    input        ena,
    input  [3:0] data,
    output [3:0] q
);

// Internal wires for D input of each flip-flop
wire d3, d2, d1, d0;

// Mux logic per bit with priority: load > enable > hold
assign d3 = load ? data[3] : (ena ? 1'b0       : q[3]);
assign d2 = load ? data[2] : (ena ? q[3]      : q[2]);
assign d1 = load ? data[1] : (ena ? q[2]      : q[1]);
assign d0 = load ? data[0] : (ena ? q[1]      : q[0]);

// Instantiate four D flip-flops with asynchronous posedge reset
DFF_AR dff3 (.clk(clk), .areset(areset), .d(d3), .q(q[3]));
DFF_AR dff2 (.clk(clk), .areset(areset), .d(d2), .q(q[2]));
DFF_AR dff1 (.clk(clk), .areset(areset), .d(d1), .q(q[1]));
DFF_AR dff0 (.clk(clk), .areset(areset), .d(d0), .q(q[0]));

endmodule

// D flip-flop with asynchronous posedge reset
module DFF_AR (
    input clk,
    input areset,
    input d,
    output reg q
);
always @(posedge clk or posedge areset) begin
    if (areset)
        q <= 1'b0;
    else
        q <= d;
end
endmodule