module counter_12 (
    input  logic        rst_n,  // Reset signal (active low)
    input  logic        clk,    // Clock signal
    input  logic        valid_count,  // Signal to enable counting
    output logic [3:0]  out     // 4-bit output representing the current count value
);

// Use an enable signal within the sequential logic to control the counting
logic enable_count;
assign enable_count = valid_count;

// Use a always_ff block to describe the sequential logic
always_ff @(posedge clk or negedge rst_n) begin
    // If the reset signal is active, reset the counter to 0
    if (!rst_n) begin
        out <= 4'b0000;
    // If the enable signal is active, increment the counter
    end else if (enable_count) begin
        out <= out + 1;
    end
end

endmodule