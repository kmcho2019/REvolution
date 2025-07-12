module counter_12 (
    input  logic        rst_n,  // Reset signal (active low)
    input  logic        clk,    // Clock signal
    input  logic        valid_count,  // Signal to enable counting
    output logic [3:0]  out     // 4-bit output representing the current count value
);

logic [3:0] next_out;
logic clk_gated; // Gated clock signal

// Clock gating
assign clk_gated = valid_count && clk;

// Reset logic
always_comb begin
    next_out = (!rst_n) ? 4'b0000 : (valid_count) ? ((out == 4'd11) ? 4'b0000 : out + 1) : out;
end

// Counting logic
always_ff @(posedge clk_gated or negedge rst_n) begin
    if (!rst_n) begin
        out <= 4'b0000;
    end else begin
        out <= next_out;
    end
end

endmodule