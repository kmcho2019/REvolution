```thought
The frequency divider module 'freq_div' will be implemented using three counters to divide the input clock frequency. 
For CLK_50, the module will toggle the signal on every positive edge of the input clock.
For CLK_10, a counter cnt_10 will be used to count the number of clock cycles and toggle the signal every 5 cycles.
For CLK_1, a counter cnt_100 will be used to count the number of clock cycles and toggle the signal every 50 cycles.
All counters will be reset when the RST signal is active.
The output signals will be assigned the divided clock frequencies.
```

```verilog
module freq_div(
    input  CLK_in,  // Input clock signal
    input  RST,    // Reset signal
    output reg CLK_50,  // Output clock signal with a frequency of CLK_in divided by 2
    output reg CLK_10,  // Output clock signal with a frequency of CLK_in divided by 10
    output reg CLK_1   // Output clock signal with a frequency of CLK_in divided by 100
);

reg [2:0] cnt_10;  // Counter for CLK_10
reg [5:0] cnt_100;  // Counter for CLK_1

always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        CLK_50 <= 0;
        CLK_10 <= 0;
        cnt_10 <= 0;
        cnt_100 <= 0;
        CLK_1 <= 0;
    end
    else begin
        CLK_50 <= ~CLK_50;  // Toggle CLK_50 on every positive edge of CLK_in
        
        cnt_10 <= cnt_10 + 1;  // Increment counter for CLK_10
        if (cnt_10 == 4) begin
            CLK_10 <= ~CLK_10;  // Toggle CLK_10 every 5 cycles
            cnt_10 <= 0;
        end
        
        cnt_100 <= cnt_100 + 1;  // Increment counter for CLK_1
        if (cnt_100 == 49) begin
            CLK_1 <= ~CLK_1;  // Toggle CLK_1 every 50 cycles
            cnt_100 <= 0;
        end
    end
end

endmodule
```

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
