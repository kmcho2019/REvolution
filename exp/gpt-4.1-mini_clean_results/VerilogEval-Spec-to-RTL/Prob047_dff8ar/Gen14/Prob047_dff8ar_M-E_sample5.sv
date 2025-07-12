// 1-bit D flip-flop with active high asynchronous reset.
// On posedge clk, if not reset, q follows d; on posedge areset, q resets to 0 immediately.
module DFF_AsyncReset_1bit (
    input       clk,
    input       areset,
    input       d,
    output reg  q
);
    always @(posedge clk or posedge areset) begin
        if (areset)
            q <= 1'b0;
        else
            q <= d;
    end
endmodule

// Top module: eight instances of 1-bit async reset DFFs forming an 8-bit register.
module TopModule (
    input         clk,
    input         areset,
    input  [7:0]  d,
    output [7:0]  q
);
    // Instantiate one DFF per bit with explicit bit connections.
    DFF_AsyncReset_1bit dff0 (.clk(clk), .areset(areset), .d(d[0]), .q(q[0]));
    DFF_AsyncReset_1bit dff1 (.clk(clk), .areset(areset), .d(d[1]), .q(q[1]));
    DFF_AsyncReset_1bit dff2 (.clk(clk), .areset(areset), .d(d[2]), .q(q[2]));
    DFF_AsyncReset_1bit dff3 (.clk(clk), .areset(areset), .d(d[3]), .q(q[3]));
    DFF_AsyncReset_1bit dff4 (.clk(clk), .areset(areset), .d(d[4]), .q(q[4]));
    DFF_AsyncReset_1bit dff5 (.clk(clk), .areset(areset), .d(d[5]), .q(q[5]));
    DFF_AsyncReset_1bit dff6 (.clk(clk), .areset(areset), .d(d[6]), .q(q[6]));
    DFF_AsyncReset_1bit dff7 (.clk(clk), .areset(areset), .d(d[7]), .q(q[7]));
endmodule