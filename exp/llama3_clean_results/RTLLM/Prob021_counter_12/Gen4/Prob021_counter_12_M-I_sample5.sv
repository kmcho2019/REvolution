module counter_12 (
    input  logic        rst_n,  // Reset signal (active low)
    input  logic        clk,    // Clock signal
    input  logic        valid_count,  // Signal to enable counting
    output logic [3:0]  out     // 4-bit output representing the current count value
);

// Internal signal to hold the next state
logic [3:0] next_out;

// Reset logic and counting logic combined
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        out <= 4'b0000; // Reset to 0 when rst_n is low
    end else if (valid_count) begin
        next_out = (out == 4'd11) ? 4'b0000 : out + 1; // Calculate next state
        out <= next_out; // Update output
    end else begin
        // Do nothing if valid_count is 0, to minimize transitions
    end
end

endmodule