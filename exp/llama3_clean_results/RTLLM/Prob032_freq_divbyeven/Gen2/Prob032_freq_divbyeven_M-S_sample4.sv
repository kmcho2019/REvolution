// Simplified version of the freq_diveven module
module freq_diveven #(
    parameter NUM_DIV = 2  // Even number division factor
) (
    input clk,        // Input clock signal
    input rst_n,      // Active-low reset signal
    output reg clk_div // Divided clock output signal
);

// Ensure NUM_DIV is an even number at compile-time
initial begin
    if (NUM_DIV % 2 != 0) begin
        $error("NUM_DIV must be an even number.");
        $finish;
    end
end

reg [3:0] cnt; // 4-bit counter to track clock cycles

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset counter and divided clock output when reset is asserted
        cnt <= 4'd0;
        clk_div <= 1'b0;
    end else if (cnt == (NUM_DIV / 2 - 1)) begin
        // Reset counter and toggle divided clock output when condition is met
        cnt <= 4'd0;
        clk_div <= ~clk_div;
    end else begin
        // Increment counter
        cnt <= cnt + 1;
    end
end

endmodule