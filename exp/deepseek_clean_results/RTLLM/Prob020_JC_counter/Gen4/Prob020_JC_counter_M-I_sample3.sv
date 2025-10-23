module JC_counter (
    input clk,
    input rst_n,
    input enable,       // Added enable signal for power optimization
    output reg [63:0] Q
);

reg [63:0] next_Q;
wire terminal_state = &Q || ~|Q;  // Detect all 1s or all 0s
wire gated_clk_en = enable && !terminal_state;  // Clock gating condition

always @(posedge clk) begin
    if (!rst_n) begin
        Q <= 64'b0;
    end
    else if (gated_clk_en) begin
        Q <= next_Q;    // Pipelined version
    end
end

// Next state calculation (pre-registered)
always @(*) begin
    next_Q = {~Q[0], Q[63:1]};
end

endmodule