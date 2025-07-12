// Corrected frequency divider module with counter and toggle flip-flop
module freq_divbyeven #(
    parameter NUM_DIV = 2  // Even number division factor
) (
    input clk,        // Input clock signal
    input rst_n,      // Active-low reset signal
    output reg clk_div // Divided clock output signal
);

// Validate NUM_DIV as an even number and greater than 1 at compile-time
initial begin
    if (NUM_DIV % 2 != 0 || NUM_DIV < 2) begin
        $error("NUM_DIV must be an even number greater than 1.");
        $finish;
    end
end

reg [$clog2(NUM_DIV)-1:0] cnt;  // Counter to track clock cycles
reg clk_div_int;  // Internal divided clock signal

// Sequential logic for counter update and divided clock output
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset counter and divided clock output when reset is asserted
        cnt <= '0;
        clk_div_int <= 1'b0;
    end else if (cnt == (NUM_DIV / 2 - 1)) begin
        // Reset counter and toggle divided clock output when limit reached
        cnt <= '0;
        clk_div_int <= ~clk_div_int;
    end else if (cnt < (NUM_DIV / 2 - 1)) begin
        // Increment counter otherwise
        cnt <= cnt + 1;
    end
end

// Assign internal divided clock signal to output
assign clk_div = clk_div_int;

endmodule