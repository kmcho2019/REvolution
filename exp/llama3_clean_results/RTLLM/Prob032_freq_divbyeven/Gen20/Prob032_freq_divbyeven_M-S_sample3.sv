module freq_diveven #(
    parameter NUM_DIV = 2  // Even number division factor
) (
    input clk,        // Input clock signal
    input rst_n,      // Active-low reset signal
    output reg clk_div // Divided clock output signal
);

// Check if NUM_DIV is an even number
initial begin
    if (NUM_DIV % 2 != 0) begin
        $fatal("NUM_DIV must be an even number.");
    end
end

reg [1:0] cnt;  // Simplified 2-bit counter

// Counter update and divided clock generation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 2'b00;
        clk_div <= 1'b0;
    end else if (cnt == (NUM_DIV / 2 - 1)) begin
        cnt <= 2'b00;  // Reset counter
        clk_div <= ~clk_div;  // Toggle divided clock output
    end else begin
        cnt <= cnt + 1;  // Increment counter
    end
end

endmodule