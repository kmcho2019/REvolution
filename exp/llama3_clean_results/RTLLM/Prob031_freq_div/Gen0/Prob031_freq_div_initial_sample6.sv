```thought
The frequency divider module, freq_div, is designed with three counters to generate output clock signals with frequencies of 50MHz, 10MHz, and 1MHz from a 100MHz input clock signal. The counters for CLK_50, CLK_10, and CLK_1 are implemented using always blocks that check for the positive edge of the input clock signal and the reset signal. 
For CLK_50, a simple toggle logic is used.
For CLK_10 and CLK_1, counters cnt_10 and cnt_100 are used to divide the frequency by 10 and 100 respectively.
The counters are reset when the reset signal is active.
```

```verilog
module freq_div(
    input CLK_in,
    input RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

reg [1:0] cnt_10; // 2-bit counter for 10MHz clock
reg [5:0] cnt_100; // 6-bit counter for 1MHz clock

always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        CLK_50 <= 1'b0;
        cnt_10 <= 2'b0;
        CLK_10 <= 1'b0;
        cnt_100 <= 6'b0;
        CLK_1 <= 1'b0;
    end else begin
        // CLK_50 generation
        CLK_50 <= ~CLK_50;
        
        // CLK_10 generation
        if (cnt_10 == 4'b1000) begin // 4 since we're counting to 5 (4+1) for a division by 10 (100MHz / 10 = 10MHz)
            cnt_10 <= 4'b0000;
            CLK_10 <= ~CLK_10;
        end else begin
            cnt_10 <= cnt_10 + 1'b1;
        end
        
        // CLK_1 generation
        if (cnt_100 == 6'b110001) begin // 49 since we're counting to 50 (49+1) for a division by 100 (100MHz / 100 = 1MHz)
            cnt_100 <= 6'b000000;
            CLK_1 <= ~CLK_1;
        end else begin
            cnt_100 <= cnt_100 + 1'b1;
        end
    end
end

endmodule
```

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
