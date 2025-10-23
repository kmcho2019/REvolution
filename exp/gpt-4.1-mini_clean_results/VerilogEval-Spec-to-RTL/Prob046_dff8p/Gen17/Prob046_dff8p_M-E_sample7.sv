module DFF_sync_reset_negclk (
    input clk,
    input reset,
    input d,
    input reset_value,
    output reg q
);
    always @(negedge clk) begin
        if (reset)
            q <= reset_value;
        else
            q <= d;
    end
endmodule

module TopModule (
    input          clk,
    input          reset,
    input  [7:0]   d,
    output [7:0]   q
);
    // Reset constant 0x34 in binary: 00110100
    // Bit positions: q[7]..q[0]
    wire [7:0] reset_val = 8'h34;

    // Instantiate 8 flip-flops individually
    DFF_sync_reset_negclk dff7 (.clk(clk), .reset(reset), .d(d[7]), .reset_value(reset_val[7]), .q(q[7]));
    DFF_sync_reset_negclk dff6 (.clk(clk), .reset(reset), .d(d[6]), .reset_value(reset_val[6]), .q(q[6]));
    DFF_sync_reset_negclk dff5 (.clk(clk), .reset(reset), .d(d[5]), .reset_value(reset_val[5]), .q(q[5]));
    DFF_sync_reset_negclk dff4 (.clk(clk), .reset(reset), .d(d[4]), .reset_value(reset_val[4]), .q(q[4]));
    DFF_sync_reset_negclk dff3 (.clk(clk), .reset(reset), .d(d[3]), .reset_value(reset_val[3]), .q(q[3]));
    DFF_sync_reset_negclk dff2 (.clk(clk), .reset(reset), .d(d[2]), .reset_value(reset_val[2]), .q(q[2]));
    DFF_sync_reset_negclk dff1 (.clk(clk), .reset(reset), .d(d[1]), .reset_value(reset_val[1]), .q(q[1]));
    DFF_sync_reset_negclk dff0 (.clk(clk), .reset(reset), .d(d[0]), .reset_value(reset_val[0]), .q(q[0]));

endmodule