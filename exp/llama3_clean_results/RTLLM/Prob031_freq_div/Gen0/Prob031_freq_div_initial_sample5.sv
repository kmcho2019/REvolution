```thought
The module freq_div is a frequency divider that takes an input clock signal CLK_in and a reset signal RST. It generates three output clock signals: CLK_50, CLK_10, and CLK_1, with frequencies of CLK_in divided by 2, 10, and 100, respectively. This will be achieved using three counters to divide the input clock frequency. The counters cnt_10 and cnt_100 are used to generate CLK_10 and CLK_1, respectively, while CLK_50 is directly toggled based on the input clock.
```

```verilog
module freq_div(
    input CLK_in,
    input RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

reg [1:0] cnt_2; // Not needed but in a normal scenario, it should be used
reg [2:0] cnt_10;
reg [5:0] cnt_100; // Counter size should be log2(100), thus 7, but in this case, we are counting to 49, thus we can use 6 bits

always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        CLK_50 <= 1'b0;
        CLK_10 <= 1'b0;
        cnt_10 <= 3'b0;
        CLK_1 <= 1'b0;
        cnt_100 <= 6'b0;
    end else begin
        // For CLK_50
        CLK_50 <= ~CLK_50;

        // For CLK_10
        if (cnt_10 == 4'd9) begin
            CLK_10 <= ~CLK_10;
            cnt_10 <= 3'b0;
        end else begin
            cnt_10 <= cnt_10 + 1;
        end

        // For CLK_1
        if (cnt_100 == 6'd49) begin
            CLK_1 <= ~CLK_1;
            cnt_100 <= 6'b0;
        end else begin
            cnt_100 <= cnt_100 + 1;
        end
    end
end

endmodule
```

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
