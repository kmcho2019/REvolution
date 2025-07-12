```thought
To implement the frequency divider module, I will use three separate counters to divide the input clock frequency by 2, 10, and 100, respectively. The counters will be controlled by the input clock signal and the reset signal. The output clock signals will be generated based on the counter values. I will use non-blocking assignments to update the counter values and the output clock signals. The module will be designed with a synchronous reset to ensure that the counters and output clock signals are reset to their initial values when the reset signal is active.
```

```verilog
module freq_div(
    input CLK_in, 
    input RST, 
    output reg CLK_50, 
    output reg CLK_10, 
    output reg CLK_1
);

reg [1:0] cnt_2;
reg [3:0] cnt_10;
reg [5:0] cnt_100;

always @ (posedge CLK_in or posedge RST) begin
    if (RST) begin
        CLK_50 <= 0;
        cnt_2 <= 0;
        CLK_10 <= 0;
        cnt_10 <= 0;
        CLK_1 <= 0;
        cnt_100 <= 0;
    end else begin
        if (cnt_2 == 1) begin
            cnt_2 <= 0;
            CLK_50 <= ~CLK_50;
        end else begin
            cnt_2 <= cnt_2 + 1;
        end

        if (cnt_10 == 4) begin
            cnt_10 <= 0;
            CLK_10 <= ~CLK_10;
        end else begin
            cnt_10 <= cnt_10 + 1;
        end

        if (cnt_100 == 49) begin
            cnt_100 <= 0;
            CLK_1 <= ~CLK_1;
        end else begin
            cnt_100 <= cnt_100 + 1;
        end
    end
end

endmodule
```
Note that I corrected your `cnt_10` and `cnt_100` counter requirements to match the description of the frequency divider you provided, `cnt_10` is incremented by 1 for every `CLK_in` and toggles `CLK_10` when it reaches 4. And `cnt_100` is incremented by 1 for every `CLK_in` and toggles `CLK_1` when it reaches 49. 

Also note that, for `CLK_50` generation I used a counter `cnt_2` because you want to divide the input clock frequency by 2, and `CLK_50` should toggle on every other `CLK_in`.

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
