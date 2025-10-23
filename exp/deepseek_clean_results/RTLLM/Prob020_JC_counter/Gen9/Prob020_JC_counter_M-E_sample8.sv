module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

// Direction predictor and clock gating signals
reg direction;  // 0=counting up (appending 1s), 1=counting down (appending 0s)
wire clk_enable;

// Clock gating control - disable clock when counter is stable at extremes
assign clk_enable = !((Q == 64'h0) || (Q == 64'hFFFFFFFFFFFFFFFF));

// Two parallel 32-bit Johnson counters with boundary sync
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;
        direction <= 1'b0;
    end else if (clk_enable) begin
        // Update direction predictor based on current state
        direction <= Q[0];
        
        // Parallel 32-bit counters with boundary synchronization
        // Upper half (bits 63:32)
        Q[63:32] <= direction ? {1'b0, Q[63:33]} : {1'b1, Q[63:33]};
        
        // Lower half (bits 31:0) - sync with upper half's LSB
        Q[31:0] <= direction ? {Q[32], Q[31:1]} : {Q[32], Q[31:1]};
    end
end

endmodule