module DFF_sync_reset_negclk (
    input  clk,
    input  reset,
    input  d,
    output reg q,
    input  preset_val
);
    always @(negedge clk) begin
        if (reset)
            q <= preset_val;
        else
            q <= d;
    end
endmodule

module TopModule (
    input        clk,
    input        reset,
    input  [7:0] d,
    output [7:0] q
);
    // Constant reset pattern 0x34 = 8'b0011_0100
    // Each bit reset value is preset_val input for each DFF

    DFF_sync_reset_negclk dff0 (.clk(clk), .reset(reset), .d(d[0]), .q(q[0]), .preset_val(1'b0));
    DFF_sync_reset_negclk dff1 (.clk(clk), .reset(reset), .d(d[1]), .q(q[1]), .preset_val(1'b0));
    DFF_sync_reset_negclk dff2 (.clk(clk), .reset(reset), .d(d[2]), .q(q[2]), .preset_val(1'b1));
    DFF_sync_reset_negclk dff3 (.clk(clk), .reset(reset), .d(d[3]), .q(q[3]), .preset_val(1'b0));
    DFF_sync_reset_negclk dff4 (.clk(clk), .reset(reset), .d(d[4]), .q(q[4]), .preset_val(1'b1));
    DFF_sync_reset_negclk dff5 (.clk(clk), .reset(reset), .d(d[5]), .q(q[5]), .preset_val(1'b1));
    DFF_sync_reset_negclk dff6 (.clk(clk), .reset(reset), .d(d[6]), .q(q[6]), .preset_val(1'b0));
    DFF_sync_reset_negclk dff7 (.clk(clk), .reset(reset), .d(d[7]), .q(q[7]), .preset_val(1'b0));

endmodule