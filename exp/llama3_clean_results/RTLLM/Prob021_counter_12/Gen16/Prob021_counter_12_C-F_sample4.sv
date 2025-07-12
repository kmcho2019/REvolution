// Module: counter_12
// Description: A 4-bit counter that counts from 0 to 11 (4'd11) and is controlled by the input signal valid_count.
//              The counter resets to 0 when the reset signal (rst_n) is active low.

module counter_12 (
    input  logic        rst_n,  // Reset signal (active low)
    input  logic        clk,    // Clock signal
    input  logic        valid_count,  // Signal to enable counting
    output logic [3:0]  out     // 4-bit output representing the current count value
);

// Generate a gated clock signal to control the counting
logic gated_clk;
assign gated_clk = valid_count ? clk : 1'b0;

// Use an always_ff block to describe the sequential logic
always_ff @(posedge gated_clk or negedge rst_n) begin
    // If the reset signal is active, reset the counter to 0
    if (!rst_n) begin
        out <= 4'b0000;
    // If the gated clock is active, increment the counter
    end else if (gated_clk) begin
        // The counter will naturally wrap around after reaching 4'd11
        out <= out + 1;
    end
end

endmodule