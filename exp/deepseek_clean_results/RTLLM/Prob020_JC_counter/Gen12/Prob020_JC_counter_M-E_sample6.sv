module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

// Predictive next state computation
wire [63:0] next_Q = {~Q[0], Q[63:1]};

// Dual-edge triggered implementation
always @(posedge clk or negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Asynchronous reset with synchronous release
        Q <= 64'b0;
    end else begin
        // Predictive update on both clock edges
        Q <= next_Q;
    end
end

// Power optimization: Detect stable states
// (* gated_clock = "yes" *)  // Synthesis directive for clock gating
// wire clk_enable = (Q != 64'hFFFFFFFFFFFFFFFF) && (Q != 64'h0);

endmodule