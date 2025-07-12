module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

// Clock gating control signals
wire terminal_state = &Q || ~|Q;  // All 1s or all 0s
wire clk_enable = !terminal_state || !rst_n;
wire gated_clk;

// Clock gating cell
CLKGATE_X1 clk_gate (
    .CK(clk),
    .E(clk_enable),
    .ECK(gated_clk)
);

// Optimized shift operation using concatenation
always @(posedge gated_clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;  // Active-low reset clears all bits
    end
    else begin
        // Shared logic for both cases
        Q <= {~Q[0], Q[63:1]};
    end
end

endmodule