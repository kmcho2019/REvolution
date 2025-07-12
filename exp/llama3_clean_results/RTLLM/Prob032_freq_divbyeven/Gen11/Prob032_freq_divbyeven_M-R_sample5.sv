// Frequency divider module by even numbers
module freq_div_even #(
    parameter NUM_DIV = 4  // Even number division factor
) (
    input clk,        // Input clock signal
    input rst_n,      // Active-low reset signal
    output reg clk_div // Divided clock output signal
);

// Validate NUM_DIV as an even number and greater than 1 at compile-time
initial begin
    if (NUM_DIV % 2!= 0) begin
        $error("NUM_DIV must be an even number.");
        $finish;
    end
    if (NUM_DIV < 2) begin
        $error("NUM_DIV must be greater than 1.");
        $finish;
    end
end

reg [3:0] cnt;        // 4-bit counter to track clock cycles
reg next_cnt;        // Next state of the counter
reg next_clk_div;    // Next state of the divided clock output

// Combinational logic for next state calculation
assign next_cnt = (cnt == (NUM_DIV/2 - 1))? '0 : cnt + 1;
assign next_clk_div = (cnt == (NUM_DIV/2 - 1))? ~clk_div : clk_div;

// Sequential logic for counter and divided clock output update
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= '0;
        clk_div <= 1'b0;
    end else begin
        cnt <= next_cnt;
        clk_div <= next_clk_div;
    end
end

endmodule