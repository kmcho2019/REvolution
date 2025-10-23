```thought
To solve this problem, we need to design a Verilog module named `freq_div` that takes an input clock `CLK_in` and a reset signal `RST`, and produces three output clocks: `CLK_50`, `CLK_10`, and `CLK_1`, with frequencies divided by 2, 10, and 100, respectively. We'll use counters to achieve the desired frequency divisions. For `CLK_50`, we simply toggle its value on every positive edge of `CLK_in`. For `CLK_10` and `CLK_1`, we use counters `cnt_10` and `cnt_100` to divide the frequency by 10 and 100, respectively, and toggle their values when the counters reach the desired thresholds. We also need to handle the reset condition where the output clocks and counters are reset to their initial states when `RST` is active.
```

```verilog
module freq_div(
    input CLK_in,
    input RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

reg [1:0] cnt_10;
reg [5:0] cnt_100;

always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        // Reset all output clocks and counters
        CLK_50 <= 0;
        CLK_10 <= 0;
        cnt_10 <= 0;
        cnt_100 <= 0;
        CLK_1 <= 0;
    end else begin
        // Toggle CLK_50 on every positive edge of CLK_in
        CLK_50 <= ~CLK_50;
        
        // Divide CLK_in by 10
        if (cnt_10 == 4) begin
            // Toggle CLK_10 and reset cnt_10
            CLK_10 <= ~CLK_10;
            cnt_10 <= 0;
        end else begin
            // Increment cnt_10
            cnt_10 <= cnt_10 + 1;
        end
        
        // Divide CLK_in by 100
        if (cnt_100 == 49) begin
            // Toggle CLK_1 and reset cnt_100
            CLK_1 <= ~CLK_1;
            cnt_100 <= 0;
        end else begin
            // Increment cnt_100
            cnt_100 <= cnt_100 + 1;
        end
    end
end

endmodule
```

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
