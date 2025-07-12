module freq_diveven(
    input clk,
    input rst_n,
    output reg clk_div
);

parameter NUM_DIV = 8; // Must be an even number

reg [3:0] cnt; // 4-bit counter to track input clock cycles
reg half_div; // Pre-calculate half of NUM_DIV - 1 for comparison

// Calculate half of NUM_DIV - 1 for comparison
always @(*) begin
    half_div = (NUM_DIV / 2) - 1;
end

// Update counter and divided clock signal based on input clock and reset
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Initialize counter and divided clock signal on reset
        cnt <= 4'd0;
        clk_div <= 1'b0;
    end else if (cnt == half_div) begin
        // Reset counter and toggle divided clock signal when limit is reached
        cnt <= 4'd0;
        clk_div <= ~clk_div;
    end else begin
        // Increment counter on each positive edge of input clock
        cnt <= cnt + 1;
    end
end

endmodule