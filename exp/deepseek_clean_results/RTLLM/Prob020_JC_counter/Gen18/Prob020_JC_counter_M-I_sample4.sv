module JC_counter #(
    parameter WIDTH = 64
) (
    input clk,
    input rst_n,
    input enable,        // Added enable signal for power control
    output reg [WIDTH-1:0] Q
);

reg [WIDTH-1:0] Q_next;  // Pipeline stage for timing improvement
wire stable_state = (Q == {WIDTH{1'b0}}) || (Q == {WIDTH{1'b1}});
wire gated_clk_en = enable && !stable_state;  // Clock gating control

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= {WIDTH{1'b0}};  // Reset to all zeros
        Q_next <= {WIDTH{1'b0}};
    end else if (enable) begin
        if (stable_state) begin
            // Hold value when in stable state to save power
            Q <= Q;
            Q_next <= Q_next;
        end else begin
            // Pipelined Johnson counter operation
            Q_next <= {~Q[0], Q[WIDTH-1:1]};
            Q <= Q_next;
        end
    end
end

endmodule