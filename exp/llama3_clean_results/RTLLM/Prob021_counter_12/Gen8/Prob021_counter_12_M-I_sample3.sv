module counter_12 (
    input  logic        rst_n,  // Reset signal (active low)
    input  logic        clk,    // Clock signal
    input  logic        valid_count,  // Signal to enable counting
    output logic [3:0]  out     // 4-bit output representing the current count value
);

logic [3:0] next_out;

// Clock gating
logic clk_gated;
assign clk_gated = valid_count && clk;

// Reset logic combined with counting logic for optimization
always_ff @(posedge clk_gated or negedge rst_n) begin
    if (!rst_n) begin
        out <= 4'b0000;
    end else if (valid_count) begin
        if (out == 4'd11) begin
            out <= 4'b0000;
        end else begin
            out <= out + 1;
        end
    end else begin
        // No need for an else condition here as out will retain its value
    end
end

endmodule