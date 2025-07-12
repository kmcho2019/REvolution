module TopModule (
    input clk,
    input d,
    output reg q
);

reg posedge_reg;
reg negedge_reg;
reg d_prev;

// Detect input stability for clock gating
always @(posedge clk) begin
    d_prev <= d;
end

wire input_stable = (d == d_prev);

// Clock-gated positive edge capture
always @(posedge clk) begin
    if (!input_stable) begin
        posedge_reg <= d;
    end
end

// Clock-gated negative edge capture
always @(negedge clk) begin
    if (!input_stable) begin
        negedge_reg <= d;
    end
end

// Optimized output selection
always @(*) begin
    q = clk ? posedge_reg : negedge_reg;
end

endmodule