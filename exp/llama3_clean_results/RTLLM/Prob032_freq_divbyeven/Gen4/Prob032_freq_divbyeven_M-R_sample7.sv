// Refactored module for frequency division by even numbers
module freq_diveven #(
    parameter NUM_DIV = 2,  // Even number division factor
    parameter WIDTH = $clog2(NUM_DIV)  // Counter width adjusted based on NUM_DIV
) (
    input clk,        // Input clock signal
    input rst_n,      // Active-low reset signal
    output reg clk_div // Divided clock output signal
);

// Validate NUM_DIV as an even number and greater than 1 at compile-time
initial begin
    if (NUM_DIV % 2 != 0) begin
        $error("NUM_DIV must be an even number.");
        $finish;
    end
    if (NUM_DIV < 2) begin
        $error("NUM_DIV must be greater than 1.");
        $finish;
    end
end

reg [WIDTH-1:0] cnt;        // Counter to track clock cycles

// Sequential logic for counter update and divided clock output
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset counter and divided clock output when reset is asserted
        cnt <= '0;
        clk_div <= 1'b0;
    end else begin
        if (cnt < (NUM_DIV / 2 - 1)) begin
            // Increment counter without changing divided clock output
            cnt <= cnt + 1;
        end else begin
            // Reset counter and toggle divided clock output
            cnt <= '0;
            clk_div <= ~clk_div;
        end
    end
end

endmodule