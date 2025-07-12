module JC_counter #(
    parameter WIDTH = 64
) (
    input clk,
    input rst_n,
    output reg [WIDTH-1:0] Q
);

(* async_reg = "true" *) reg [WIDTH-1:0] Q_reg;  // Better timing closure
wire stable_state = &Q || ~|Q;  // Detect all 1s or all 0s
wire gated_clk = clk & ~stable_state;  // Clock gating logic

always @(posedge gated_clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= {WIDTH{1'b0}};  // Active-low reset
    end else begin
        // Optimized shift operation with reduced logic depth
        Q <= {~Q[0], Q[WIDTH-1:1]};
    end
end

// Optional: Uncomment for additional pipeline stage if needed
// always @(posedge clk) Q_reg <= Q;

endmodule