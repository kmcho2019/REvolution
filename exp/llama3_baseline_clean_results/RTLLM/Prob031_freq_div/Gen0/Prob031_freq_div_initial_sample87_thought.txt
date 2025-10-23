```thought
To implement the frequency divider module, we need to create a Verilog module named 'freq_div' with the specified input and output ports. The module will use three counters to divide the input clock frequency to generate the desired output frequencies. The counters will be used to generate CLK_50, CLK_10, and CLK_1 signals. The counters cnt_10 and cnt_100 will be reset to 0 when RST is active. The CLK_50 signal will be toggled on every positive edge of CLK_in or RST. The counters will be incremented on every positive edge of CLK_in, and when they reach their respective thresholds, the corresponding output clock signals will be toggled and the counters will be reset.
```

```verilog
module freq_div(
    input CLK_in,
    input RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

reg [1:0] cnt_2 = 0;
reg [2:0] cnt_10 = 0;
reg [5:0] cnt_100 = 0;

always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        CLK_50 <= 0;
        CLK_10 <= 0;
        CLK_1 <= 0;
        cnt_2 <= 0;
        cnt_10 <= 0;
        cnt_100 <= 0;
    end else begin
        // Generate CLK_50
        cnt_2 <= cnt_2 + 1;
        if (cnt_2 == 1) begin
            CLK_50 <= ~CLK_50;
            cnt_2 <= 0;
        end
        
        // Generate CLK_10
        cnt_10 <= cnt_10 + 1;
        if (cnt_10 == 4) begin
            CLK_10 <= ~CLK_10;
            cnt_10 <= 0;
        end
        
        // Generate CLK_1
        cnt_100 <= cnt_100 + 1;
        if (cnt_100 == 49) begin
            CLK_1 <= ~CLK_1;
            cnt_100 <= 0;
        end
    end
end

endmodule
```
Note: There was a small mistake in the original thought, where it said `cnt_10` should be incremented by `1` until it reaches `4`, then reset. However, a frequency divider of `10` should count up to `9` (since it needs to divide by `10`), so I changed `cnt_10` to count up to `4` to achieve the division by `10` for `CLK_10`, but for `CLK_50` we should divide the clock by `2` so we just need a counter that counts up to `1`. Also, the counter for `CLK_1` needs to count up to `49` (not `99` or `100`) since we need to divide the clock by `100`, which would be `100/2 = 50`, then we divide by `2` again, `50/2 = 25`, and finally `25 * 2 = 50`, so the counter for `CLK_1` should count up to `49` (not `99` or `100`) to get a frequency of `1MHz`.

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
