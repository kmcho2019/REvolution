```thought
To design the frequency divider module 'freq_div', we will utilize three separate counters to generate the desired output frequencies. 
The first counter will be used to generate the 50MHz clock signal (CLK_50) by inverting its current value on every positive edge of the input clock (CLK_in).
The second counter will be used to generate the 10MHz clock signal (CLK_10) by inverting its current value when it reaches a count of 4.
The third counter will be used to generate the 1MHz clock signal (CLK_1) by inverting its current value when it reaches a count of 49.
We will use the reset signal (RST) to reset all counters and output clock signals.
```
```verilog
module freq_div (
    input  logic CLK_in,
    input  logic RST,
    output logic CLK_50,
    output logic CLK_10,
    output logic CLK_1
);

logic [1:0] cnt_2;
logic [2:0] cnt_10;
logic [5:0] cnt_100;

always_ff @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        // Reset all counters and clock signals
        cnt_2 <= 0;
        cnt_10 <= 0;
        cnt_100 <= 0;
        CLK_50 <= 0;
        CLK_10 <= 0;
        CLK_1 <= 0;
    end else begin
        // Toggle CLK_50
        CLK_50 <= ~CLK_50;
        
        // Increment cnt_10 and toggle CLK_10 when it reaches 4
        if (cnt_10 == 4) begin
            cnt_10 <= 0;
            CLK_10 <= ~CLK_10;
        end else begin
            cnt_10 <= cnt_10 + 1;
        end
        
        // Increment cnt_100 and toggle CLK_1 when it reaches 49
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

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
