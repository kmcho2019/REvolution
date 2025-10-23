module counter_12 (
    input  logic        rst_n,  // Reset signal (active low)
    input  logic        clk,    // Clock signal
    input  logic        valid_count,  // Signal to enable counting
    output logic [3:0]  out     // 4-bit output representing the current count value
);

// Directly generate the gated clock signal using assign
logic gated_clk;
assign gated_clk = clk & valid_count;

// Sequential logic directly updates the output register
always_ff @(posedge gated_clk or negedge rst_n) begin
    if (!rst_n) begin
        out <= 4'b0000;
    end else if (valid_count) begin
        out <= out + 1;  // Let the counter naturally wrap around when exceeding 11
    end else begin
        out <= out;  // Keep the current value when valid_count is low
    end
end

endmodule