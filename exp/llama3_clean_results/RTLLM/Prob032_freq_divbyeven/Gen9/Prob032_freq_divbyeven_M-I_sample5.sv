// Improved module for frequency division by even numbers
module freq_diveven #(
    parameter NUM_DIV = 2  // Even number division factor, must be greater than 0
) (
    input clk,        // Input clock signal
    input rst_n,      // Active-low reset signal
    output reg clk_div // Divided clock output signal
);

localparam CNT_WIDTH = $clog2(NUM_DIV / 2);  // Calculate counter width based on half of NUM_DIV for optimization
reg [CNT_WIDTH-1:0] cnt;  // Counter to track clock cycles

// Sequential logic for counter update and divided clock output
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= '0;
        clk_div <= 1'b0;
    end else if (cnt == (NUM_DIV / 2 - 1)) begin
        cnt <= '0;
        clk_div <= ~clk_div;
    end else begin
        cnt <= cnt + 1;
    end
end

endmodule