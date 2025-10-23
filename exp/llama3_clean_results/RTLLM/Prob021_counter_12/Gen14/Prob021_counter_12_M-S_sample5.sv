module counter_12 (
    input  logic        rst_n,  // Reset signal (active low)
    input  logic        clk,    // Clock signal
    input  logic        valid_count,  // Signal to enable counting
    output logic [3:0]  out     // 4-bit output representing the current count value
);

// Gated clock for power reduction
logic gated_clk;
assign gated_clk = clk & valid_count;

// Sequential logic with gated clock and simplified condition
always_ff @(posedge gated_clk or negedge rst_n) begin
    if (!rst_n) begin
        out <= 4'b0000;
    end else if (out == 4'd11) begin
        out <= 4'b0000;
    end else if (valid_count) begin
        out <= out + 1;
    end
end

endmodule