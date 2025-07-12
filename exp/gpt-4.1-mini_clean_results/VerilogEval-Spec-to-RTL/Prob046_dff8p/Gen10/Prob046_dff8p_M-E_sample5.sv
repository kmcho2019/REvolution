module DFF_sync_reset_negclk_bit #(
    parameter RESET_VAL = 1'b0
) (
    input        clk,
    input        reset,
    input        d,
    output reg   q
);
    // Negative edge triggered DFF with synchronous active-high reset
    always @(negedge clk) begin
        if (reset)
            q <= RESET_VAL;
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
    // Reset value 0x34: binary 00110100
    // Map bits explicitly: q[7]=0, q[6]=0, q[5]=1, q[4]=1, q[3]=0, q[2]=1, q[1]=0, q[0]=0
    // Instantiate 8 DFFs individually
    DFF_sync_reset_negclk_bit #(.RESET_VAL(1'b0)) dff7 (.clk(clk), .reset(reset), .d(d[7]), .q(q[7]));
    DFF_sync_reset_negclk_bit #(.RESET_VAL(1'b0)) dff6 (.clk(clk), .reset(reset), .d(d[6]), .q(q[6]));
    DFF_sync_reset_negclk_bit #(.RESET_VAL(1'b1)) dff5 (.clk(clk), .reset(reset), .d(d[5]), .q(q[5]));
    DFF_sync_reset_negclk_bit #(.RESET_VAL(1'b1)) dff4 (.clk(clk), .reset(reset), .d(d[4]), .q(q[4]));
    DFF_sync_reset_negclk_bit #(.RESET_VAL(1'b0)) dff3 (.clk(clk), .reset(reset), .d(d[3]), .q(q[3]));
    DFF_sync_reset_negclk_bit #(.RESET_VAL(1'b1)) dff2 (.clk(clk), .reset(reset), .d(d[2]), .q(q[2]));
    DFF_sync_reset_negclk_bit #(.RESET_VAL(1'b0)) dff1 (.clk(clk), .reset(reset), .d(d[1]), .q(q[1]));
    DFF_sync_reset_negclk_bit #(.RESET_VAL(1'b0)) dff0 (.clk(clk), .reset(reset), .d(d[0]), .q(q[0]));

endmodule