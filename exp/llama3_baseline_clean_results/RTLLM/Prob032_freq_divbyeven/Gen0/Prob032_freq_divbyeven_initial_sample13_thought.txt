```thought
To solve this problem, we need to create a frequency divider module in Verilog that takes an input clock signal and an active-low reset signal, and outputs a divided clock signal. The division factor will be specified by the `NUM_DIV` parameter, which must be an even number. We will use a counter to count the number of clock cycles and toggle the output signal when the counter reaches half of `NUM_DIV - 1`. The counter will be implemented as a 4-bit register. On each positive edge of the input clock, if the counter is less than half of `NUM_DIV - 1`, the counter will increment without changing the divided clock output. When the counter reaches the specified limit, it will reset to zero and toggle the `clk_div` output signal.
```
```verilog
module freq_diveven #(
    parameter NUM_DIV = 10 // Division factor, must be an even number
) (
    input clk, // Input clock signal
    input rst_n, // Active-low reset signal
    output reg clk_div // Divided clock output signal
);

reg [3:0] cnt; // 4-bit counter

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset counter and divided clock output on reset
        cnt <= 4'b0;
        clk_div <= 1'b0;
    end else begin
        if (cnt < (NUM_DIV / 2 - 1)) begin
            // Increment counter without changing divided clock output
            cnt <= cnt + 1'b1;
        end else begin
            // Reset counter and toggle divided clock output
            cnt <= 4'b0;
            clk_div <= ~clk_div;
        end
    end
end

endmodule
```
This module is now complete and ready for use. The `freq_diveven` module takes in a clock signal `clk` and an active-low reset signal `rst_n`, and outputs a divided clock signal `clk_div`. The division factor is specified by the `NUM_DIV` parameter, which must be an even number. The module uses a 4-bit counter to track the number of clock cycles and toggles the output signal when the counter reaches half of `NUM_DIV - 1`.

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
