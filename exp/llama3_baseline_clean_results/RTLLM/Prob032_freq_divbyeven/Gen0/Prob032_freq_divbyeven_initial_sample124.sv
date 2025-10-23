```thought
To implement the frequency divider module `freq_diveven`, we'll define a Verilog module with the specified input and output ports. The module will use a parameter `NUM_DIV` to specify the division factor, which must be an even number. We will use a 4-bit counter (`cnt`) to track the number of clock cycles. On each positive edge of the input clock (`clk`), we'll check if the counter has reached the specified limit (half of `NUM_DIV - 1`) and if so, reset the counter and toggle the divided clock output (`clk_div`). The `rst_n` signal will be used to initialize the counter and `clk_div` to zero when it's low.
```

```verilog
module freq_diveven #(
    parameter NUM_DIV = 10  // Even number division factor
) (
    input  clk,
    input  rst_n,
    output reg clk_div
);

reg [3:0] cnt;  // 4-bit counter

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 4'd0;
        clk_div <= 1'b0;
    end else begin
        if (cnt < (NUM_DIV / 2 - 1)) begin
            cnt <= cnt + 1;
        end else begin
            cnt <= 4'd0;
            clk_div <= ~clk_div;
        end
    end
end

endmodule
```

Note: The division factor `NUM_DIV` must be an even number. If an odd number is provided, the module's behavior may not be as expected. In a real-world scenario, you might want to add checks to ensure `NUM_DIV` is even.

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
