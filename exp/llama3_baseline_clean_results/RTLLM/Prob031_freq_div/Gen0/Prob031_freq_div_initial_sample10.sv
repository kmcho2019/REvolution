```thought
To implement the frequency divider module 'freq_div', we will use three counters to divide the input clock frequency. The counters will be used to generate the output clock signals with frequencies of 50MHz, 10MHz, and 1MHz. We will use the 'always' block to describe the behavior of the counters and the output clock signals. The counters will be reset when the reset signal 'RST' is active. The output clock signals will be toggled when their respective counters reach the desired values.
```

```verilog
module freq_div (
    input CLK_in,    // Input clock signal
    input RST,       // Reset signal
    output reg CLK_50,  // Output clock signal with a frequency of CLK_in divided by 2
    output reg CLK_10,  // Output clock signal with a frequency of CLK_in divided by 10
    output reg CLK_1   // Output clock signal with a frequency of CLK_in divided by 100
);

reg [1:0] cnt_2;     // Counter for CLK_50
reg [2:0] cnt_10;    // Counter for CLK_10
reg [5:0] cnt_100;   // Counter for CLK_1

always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        // Reset all counters and output clock signals
        CLK_50 <= 0;
        CLK_10 <= 0;
        CLK_1 <= 0;
        cnt_2 <= 0;
        cnt_10 <= 0;
        cnt_100 <= 0;
    end else begin
        // Generate CLK_50
        if (cnt_2 == 1) begin
            cnt_2 <= 0;
            CLK_50 <= ~CLK_50;
        end else begin
            cnt_2 <= cnt_2 + 1;
        end

        // Generate CLK_10
        if (cnt_10 == 4) begin
            cnt_10 <= 0;
            CLK_10 <= ~CLK_10;
        end else begin
            cnt_10 <= cnt_10 + 1;
        end

        // Generate CLK_1
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
