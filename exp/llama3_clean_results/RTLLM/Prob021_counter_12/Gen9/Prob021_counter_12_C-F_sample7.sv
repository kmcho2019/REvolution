module counter_12 (
    input  logic        rst_n,  // Reset signal (active low)
    input  logic        clk,    // Clock signal
    input  logic        valid_count,  // Signal to enable counting
    output logic [3:0]  out     // 4-bit output representing the current count value
);

// Simplified counting logic with direct wrap-around
logic [3:0] next_out;
assign next_out = (!rst_n) ? 4'b0000 : (valid_count && out == 4'd11) ? 4'b0000 : (valid_count) ? out + 1 : out;

// Sequential logic with clock enable
always_ff @(posedge clk) begin
    if (!rst_n) begin
        out <= 4'b0000;
    end else if (valid_count) begin
        out <= next_out;
    end
end

endmodule