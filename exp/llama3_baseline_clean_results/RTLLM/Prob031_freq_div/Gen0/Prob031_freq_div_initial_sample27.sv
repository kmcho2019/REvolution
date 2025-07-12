```thought
To implement the frequency divider, we will create a module named 'freq_div' with input ports 'CLK_in' and 'RST', and output ports 'CLK_50', 'CLK_10', and 'CLK_1'. We will use three counters to divide the input clock frequency. For 'CLK_50', we will simply toggle the signal on every positive edge of 'CLK_in'. For 'CLK_10' and 'CLK_1', we will use counters 'cnt_10' and 'cnt_100' respectively, to divide the frequency by 10 and 100. On every positive edge of 'CLK_in', we will check the counter values and toggle the corresponding clock signals when the counter reaches the desired value. The 'RST' signal will be used to reset the counters and clock signals.
```

```verilog
module freq_div(
    input CLK_in,
    input RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg [4:0] cnt_10,
    output reg [6:0] cnt_100,
    output reg CLK_1
);

always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        CLK_50 <= 1'b0;
        CLK_10 <= 1'b0;
        cnt_10 <= 5'b0;
        cnt_100 <= 7'b0;
        CLK_1 <= 1'b0;
    end else begin
        CLK_50 <= ~CLK_50;
        
        if (cnt_10 == 5'b100) begin
            CLK_10 <= ~CLK_10;
            cnt_10 <= 5'b0;
        end else begin
            cnt_10 <= cnt_10 + 1;
        end

        if (cnt_100 == 7'b110001) begin
            CLK_1 <= ~CLK_1;
            cnt_100 <= 7'b0;
        end else begin
            cnt_100 <= cnt_100 + 1;
        end
    end
end

endmodule
```

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
