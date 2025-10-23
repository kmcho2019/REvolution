module JC_counter #(
    parameter WIDTH = 64
) (
    input clk,
    input rst_n,
    output reg [WIDTH-1:0] Q
);

// Clock gating control - disable when in stable states
wire counter_active = !((&Q) || (|Q) == 0);
wire gated_clk = clk & counter_active;

always @(posedge gated_clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= {WIDTH{1'b0}};  // Reset to all zeros
    end else begin
        Q <= {~Q[0], Q[WIDTH-1:1]};  // Johnson counter logic
    end
end

endmodule