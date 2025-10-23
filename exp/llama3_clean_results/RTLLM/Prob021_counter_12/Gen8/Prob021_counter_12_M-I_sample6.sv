module counter_12 (
    input  logic        rst_n,  // Reset signal (active low)
    input  logic        clk,    // Clock signal
    input  logic        valid_count,  // Signal to enable counting
    output logic [3:0]  out     // 4-bit output representing the current count value
);

// Simplified counting logic with direct wrap-around
logic [3:0] next_out;
always_comb begin
    if (!rst_n) begin
        next_out = 4'b0000;
    end else if (valid_count) begin
        // Simplified comparison for wrap-around
        if (out == 4'd11) begin
            next_out = 4'd0;
        end else begin
            next_out = out + 1;
        end
    end else begin
        next_out = out;
    end
end

// Clock gating for power reduction
logic gated_clk;
assign gated_clk = valid_count? clk : 1'b0;

// Sequential logic with gated clock and optimization for area and power
always_ff @(posedge gated_clk or negedge rst_n) begin
    if (!rst_n) begin
        out <= 4'b0000;
    end else if (gated_clk) begin
        // Update output only when necessary to reduce switching activity
        out <= next_out;
    end
end

endmodule