// Refactored module for frequency division by even numbers
module freq_diveven #(
    parameter NUM_DIV = 2  // Even number division factor
) (
    input clk,        // Input clock signal
    input rst_n,      // Active-low reset signal
    output reg clk_div // Divided clock output signal
);

// Validate NUM_DIV as an even number and greater than 1 at compile-time
initial begin
    if (NUM_DIV <= 1) begin
        $error("NUM_DIV must be greater than 1.");
        $finish;
    end
    if (NUM_DIV % 2 != 0) begin
        $error("NUM_DIV must be an even number.");
        $finish;
    end
end

reg [3:0] cnt;        // 4-bit counter to track clock cycles
reg prev_cnt;         // Previous state of the counter

// Sequential logic for counter update
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= '0;
        prev_cnt <= 0;
        clk_div <= 0;
    end else begin
        prev_cnt <= cnt;
        if (cnt == (NUM_DIV/2 - 1)) begin
            cnt <= '0;
            clk_div <= ~clk_div;
        end else begin
            cnt <= cnt + 1;
        end
    end
end

endmodule