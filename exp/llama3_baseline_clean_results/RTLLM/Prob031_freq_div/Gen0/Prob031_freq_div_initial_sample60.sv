```thought
The frequency divider module will be implemented using three counters to divide the input clock frequency. 
The first counter will be used to generate the 50MHz clock signal by toggling its current value on every positive edge of the input clock signal. 
The second counter will be used to generate the 10MHz clock signal by counting up to 4 and then toggling its current value and resetting the counter. 
The third counter will be used to generate the 1MHz clock signal by counting up to 49 and then toggling its current value and resetting the counter. 
All counters and output signals will be reset to their initial state when the reset signal is active.
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
        cnt_2 <= 2'b00;
        CLK_10 <= 1'b0;
        cnt_10 <= 3'b000;
        CLK_1 <= 1'b0;
        cnt_100 <= 6'b000000;
    end else begin
        if (cnt_2 == 2'b01) begin
            CLK_50 <= ~CLK_50;
            cnt_2 <= 2'b00;
        end else begin
            cnt_2 <= cnt_2 + 1;
        end
        
        if (cnt_10 == 4) begin
            CLK_10 <= ~CLK_10;
            cnt_10 <= 3'b000;
        end else begin
            cnt_10 <= cnt_10 + 1;
        end
        
        if (cnt_100 == 49) begin
            CLK_1 <= ~CLK_1;
            cnt_100 <= 6'b000000;
        end else begin
            cnt_100 <= cnt_100 + 1;
        end
    end
end

endmodule
```
However, this implementation doesn't perfectly match your specifications as we don't need `cnt_2` counter for `CLK_50`. For `CLK_50`, we can simply toggle its value every positive edge of `CLK_in`. Here's the corrected code:

```verilog
module freq_div (
    input CLK_in,
    input RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

reg [2:0] cnt_10;
reg [5:0] cnt_100;

always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        CLK_50 <= 1'b0;
        CLK_10 <= 1'b0;
        cnt_10 <= 3'b000;
        CLK_1 <= 1'b0;
        cnt_100 <= 6'b000000;
    end else begin
        CLK_50 <= ~CLK_50;
        
        if (cnt_10 == 4) begin
            CLK_10 <= ~CLK_10;
            cnt_10 <= 3'b000;
        end else begin
            cnt_10 <= cnt_10 + 1;
        end
        
        if (cnt_100 == 49) begin
            CLK_1 <= ~CLK_1;
            cnt_100 <= 6'b000000;
        end else begin
            cnt_100 <= cnt_100 + 1;
        end
    end
end

endmodule
```
This Verilog code defines a frequency divider module that generates three output clock signals with frequencies of 50MHz, 10MHz, and 1MHz from an input clock signal of 100MHz. The module uses counters to achieve the frequency division and resets all counters and output signals when the reset signal is active.

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
