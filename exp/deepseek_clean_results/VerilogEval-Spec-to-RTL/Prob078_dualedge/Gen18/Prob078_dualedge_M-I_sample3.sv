module TopModule (
    input clk,
    input d,
    output reg q
);

reg pos_edge_ff;
reg neg_edge_ff;
reg q_reg;

// Positive edge triggered flip-flop (always active)
always @(posedge clk) begin
    pos_edge_ff <= d;
end

// Negative edge triggered flip-flop (clock-gated)
always @(negedge clk) begin
    if (~clk) begin  // Implicit clock gating
        neg_edge_ff <= d;
    end
end

// Registered output to improve timing
always @(posedge clk) begin
    q_reg <= clk ? pos_edge_ff : neg_edge_ff;
end

assign q = q_reg;

endmodule