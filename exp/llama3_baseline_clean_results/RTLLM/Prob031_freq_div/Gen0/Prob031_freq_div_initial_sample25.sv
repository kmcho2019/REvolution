```thought
To implement the frequency divider module, we will use three counters to divide the input clock frequency. 
We will use a single process to handle the reset and clock edge events, and update the counters and clock signals accordingly.
For CLK_50, we simply toggle the signal on every positive edge of the input clock.
For CLK_10 and CLK_1, we use separate counters to track when to toggle the signals.
The counters are reset when the reset signal is active, and the clock signals are updated based on the counter values.
```

```verilog
module freq_div(
    input  CLK_in,
    input  RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

reg [1:0] cnt_2;  // Not needed, as we can directly toggle CLK_50
reg [2:0] cnt_10; // Counter for CLK_10
reg [5:0] cnt_100; // Counter for CLK_1

always @(posedge CLK_in or posedge RST) begin
    if(RST) begin
        // Reset all counters and signals when RST is active
        CLK_50 <= 1'b0;
        CLK_10 <= 1'b0;
        CLK_1  <= 1'b0;
        cnt_10 <= 3'b000;
        cnt_100 <= 6'b00000;
    end else begin
        // Update counters and signals
        CLK_50 <= ~CLK_50; // Toggle CLK_50
        cnt_10 <= cnt_10 + 1'b1; // Increment counter for CLK_10
        if(cnt_10 == 4'b1000) begin // If counter reaches 10
            CLK_10 <= ~CLK_10; // Toggle CLK_10
            cnt_10 <= 3'b000; // Reset counter for CLK_10
        end
        cnt_100 <= cnt_100 + 1'b1; // Increment counter for CLK_1
        if(cnt_100 == 6'b110001) begin // If counter reaches 100
            CLK_1 <= ~CLK_1; // Toggle CLK_1
            cnt_100 <= 6'b00000; // Reset counter for CLK_1
        end
    end
end

endmodule
```
This code implements the frequency divider module as described, with three counters to divide the input clock frequency and produce the desired output frequencies. The counters are reset when the reset signal is active, and the clock signals are updated based on the counter values.

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
