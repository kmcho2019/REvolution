module DFF_sync_reset (
    input       clk,
    input       reset,
    input       d,
    output reg  q
);
    always @(posedge clk) begin
        if (reset)
            q <= 1'b0;
        else
            q <= d;
    end
endmodule

module TopModule (
    input           clk,
    input           reset,
    input  [7:0]    d,
    output [7:0]    q
);
    // Instantiate 8 separate DFF modules for each bit
    DFF_sync_reset dff0 (.clk(clk), .reset(reset), .d(d[0]), .q(q[0]));
    DFF_sync_reset dff1 (.clk(clk), .reset(reset), .d(d[1]), .q(q[1]));
    DFF_sync_reset dff2 (.clk(clk), .reset(reset), .d(d[2]), .q(q[2]));
    DFF_sync_reset dff3 (.clk(clk), .reset(reset), .d(d[3]), .q(q[3]));
    DFF_sync_reset dff4 (.clk(clk), .reset(reset), .d(d[4]), .q(q[4]));
    DFF_sync_reset dff5 (.clk(clk), .reset(reset), .d(d[5]), .q(q[5]));
    DFF_sync_reset dff6 (.clk(clk), .reset(reset), .d(d[6]), .q(q[6]));
    DFF_sync_reset dff7 (.clk(clk), .reset(reset), .d(d[7]), .q(q[7]));
endmodule