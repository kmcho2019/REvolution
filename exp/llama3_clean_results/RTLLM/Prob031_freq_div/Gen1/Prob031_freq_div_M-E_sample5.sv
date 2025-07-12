```thought
The module freq_div is a frequency divider that takes an input clock signal CLK_in and a reset signal RST. It generates three output clock signals: CLK_50, CLK_10, and CLK_1, with frequencies of CLK_in divided by 2, 10, and 100, respectively. This will be achieved using a single counter to divide the input clock frequency. The counter will be used to generate all three output clock signals by checking its value against different thresholds.
```

```verilog
module freq_div(
    input CLK_in,
    input RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

reg [6:0] counter; // Counter size should be log2(100), thus 7

always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        counter <= 7'b0;
        CLK_50 <= 1'b0;
        CLK_10 <= 1'b0;
        CLK_1 <= 1'b0;
    end else begin
        counter <= counter + 1;
        
        // For CLK_50
        if (counter[0] == 1'b1) begin
            CLK_50 <= ~CLK_50;
        end

        // For CLK_10
        if (counter == 7'd9) begin
            CLK_10 <= ~CLK_10;
        end

        // For CLK_1
        if (counter == 7'd99) begin
            CLK_1 <= ~CLK_1;
        end
    end
end

endmodule
```

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
