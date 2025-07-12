```thought
To implement the frequency divider, we will use three counters to divide the input clock frequency. We will use one counter for each output clock signal. The counters will be incremented on every positive edge of the input clock signal or reset signal. The output clock signals will be toggled when their respective counters reach the desired values. We will use the Verilog language to describe the frequency divider module.
```

```verilog
module freq_div (
    input CLK_in,
    input RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

reg [1:0] cnt_2;
reg [2:0] cnt_10;
reg [5:0] cnt_100;

always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        CLK_50 <= 1'b0;
        cnt_2 <= 2'b0;
        CLK_10 <= 1'b0;
        cnt_10 <= 3'b0;
        CLK_1 <= 1'b0;
        cnt_100 <= 6'b0;
    end else begin
        // Generate CLK_50
        if (cnt_2 == 2'b1) begin
            CLK_50 <= ~CLK_50;
            cnt_2 <= 2'b0;
        end else begin
            cnt_2 <= cnt_2 + 1'b1;
        end
        
        // Generate CLK_10
        if (cnt_10 == 4'b100) begin
            CLK_10 <= ~CLK_10;
            cnt_10 <= 3'b0;
        end else begin
            cnt_10 <= cnt_10 + 1'b1;
        end
        
        // Generate CLK_1
        if (cnt_100 == 6'b110001) begin
            CLK_1 <= ~CLK_1;
            cnt_100 <= 6'b0;
        end else begin
            cnt_100 <= cnt_100 + 1'b1;
        end
    end
end

endmodule
```

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
