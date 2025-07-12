module DFF_NegEdgeSyncReset (
    input  clk,
    input  reset,
    input  d,
    output reg q,
    input  reset_val
);
    always @(negedge clk) begin
        if (reset)
            q <= reset_val;
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
    // Reset value 0x34 = 8'b00110100
    // Instantiate 8 D flip-flops, each with synchronous reset to reset_val bit
    DFF_NegEdgeSyncReset dff0(.clk(clk), .reset(reset), .d(d[0]), .q(q[0]), .reset_val(1'b0));
    DFF_NegEdgeSyncReset dff1(.clk(clk), .reset(reset), .d(d[1]), .q(q[1]), .reset_val(1'b0));
    DFF_NegEdgeSyncReset dff2(.clk(clk), .reset(reset), .d(d[2]), .q(q[2]), .reset_val(1'b1));
    DFF_NegEdgeSyncReset dff3(.clk(clk), .reset(reset), .d(d[3]), .q(q[3]), .reset_val(1'b0));
    DFF_NegEdgeSyncReset dff4(.clk(clk), .reset(reset), .d(d[4]), .q(q[4]), .reset_val(1'b1));
    DFF_NegEdgeSyncReset dff5(.clk(clk), .reset(reset), .d(d[5]), .q(q[5]), .reset_val(1'b1));
    DFF_NegEdgeSyncReset dff6(.clk(clk), .reset(reset), .d(d[6]), .q(q[6]), .reset_val(1'b0));
    DFF_NegEdgeSyncReset dff7(.clk(clk), .reset(reset), .d(d[7]), .q(q[7]), .reset_val(1'b0));

endmodule