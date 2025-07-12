// Define the module with the correct name
module freq_diveven #(
    parameter NUM_DIV = 2,  // Even number division factor
    parameter WIDTH = $clog2(NUM_DIV)  // Counter width adjusted based on NUM_DIV
) (
    input clk,        // Input clock signal
    input rst_n,      // Active-low reset signal
    output reg clk_div // Divided clock output signal
);

// Check if NUM_DIV is an even number at compile-time (using $error for simplicity)
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

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset counter and output clock when reset is asserted
        cnt <= '0;
        clk_div <= 1'b0;
    end else begin
        if (cnt < (NUM_DIV / 2 - 1)) begin
            // Increment counter without changing the output clock
            cnt <= cnt + 1;
        end else begin
            // Reset counter and toggle the output clock
            cnt <= '0;
            clk_div <= ~clk_div;
        end
    end
end

endmodule