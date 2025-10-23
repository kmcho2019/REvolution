```thought
To implement the frequency divider module 'freq_div', we will use three counters to divide the input clock frequency. The first counter will divide the clock frequency by 2 to generate the 50MHz clock signal. The second counter will divide the clock frequency by 10 to generate the 10MHz clock signal. The third counter will divide the clock frequency by 100 to generate the 1MHz clock signal. The counters will be reset when the reset signal 'RST' is active. On every positive edge of 'CLK_in' or 'RST', the counters will be updated according to their respective conditions. The clock signals 'CLK_50', 'CLK_10', and 'CLK_1' will be generated based on the counter values.
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

always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        // Reset all counters and clock signals
        CLK_50 <= 0;
        CLK_10 <= 0;
        CLK_1 <= 0;
        cnt_2 <= 0;
        cnt_10 <= 0;
        cnt_100 <= 0;
    end else begin
        // Generate 50MHz clock signal
        if (cnt_2 == 1) begin
            CLK_50 <= ~CLK_50;
            cnt_2 <= 0;
        end else begin
            cnt_2 <= cnt_2 + 1;
        end

        // Generate 10MHz clock signal
        if (cnt_10 == 4) begin
            CLK_10 <= ~CLK_10;
            cnt_10 <= 0;
        end else begin
            cnt_10 <= cnt_10 + 1;
        end

        // Generate 1MHz clock signal
        if (cnt_100 == 49) begin
            CLK_1 <= ~CLK_1;
            cnt_100 <= 0;
        end else begin
            cnt_100 <= cnt_100 + 1;
        end
    end
end

endmodule
```

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
