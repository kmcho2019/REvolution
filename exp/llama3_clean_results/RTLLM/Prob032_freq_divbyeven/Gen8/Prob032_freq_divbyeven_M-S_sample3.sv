module freq_diveven(
    input clk,
    input rst_n,
    output reg clk_div
);

parameter NUM_DIV = 8; // Must be an even number

reg [3:0] cnt; // 4-bit counter to track input clock cycles

// Update counter and divided clock signal based on input clock and reset
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Initialize counter and divided clock signal on reset
        cnt <= 4'd0;
        clk_div <= 1'b0;
    end else if (cnt == (NUM_DIV / 2) - 1) begin
        // Reset counter and toggle divided clock signal when limit is reached
        cnt <= 4'd0;
        clk_div <= ~clk_div;
    end else begin
        // Increment counter on each positive edge of input clock
        cnt <= cnt + 1;
    end
end

endmodule