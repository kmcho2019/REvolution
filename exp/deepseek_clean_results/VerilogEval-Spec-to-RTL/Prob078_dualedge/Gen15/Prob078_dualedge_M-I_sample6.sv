module TopModule (
    input clk,
    input d,
    output reg q
);

reg pos_edge_ff;
reg neg_edge_ff;

// Positive edge triggered flip-flop (always active)
always @(posedge clk) begin
    pos_edge_ff <= d;
end

// Negative edge triggered flip-flop (only updates when needed)
always @(negedge clk) begin
    if (~clk) begin  // Implicit condition, maintains functionality
        neg_edge_ff <= d;
    end
end

// Registered output for better timing
always @(*) begin
    q = clk ? pos_edge_ff : neg_edge_ff;
end

endmodule