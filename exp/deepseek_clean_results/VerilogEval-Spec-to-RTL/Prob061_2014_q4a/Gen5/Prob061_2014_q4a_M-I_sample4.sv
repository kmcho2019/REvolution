module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output Q
);

reg state;
wire next_state;
wire clk_en;

// Clock gating - only enable clock when state might change
assign clk_en = L | E;

// Optimized next state logic
assign next_state = L ? R : (E ? w : state);

// State register with clock gating
always @(posedge clk) begin
    if (clk_en) begin
        state <= next_state;
    end
end

// Continuous output assignment
assign Q = state;

endmodule