```thought
To implement the frequency divider module `freq_div`, we will use three counters to divide the input clock frequency. We'll utilize an always block to capture the rising edge of the input clock and reset signal. For each clock output (CLK_50, CLK_10, CLK_1), we'll implement the specified logic to generate the desired frequency. The counters cnt_10 and cnt_100 will be used to keep track of the number of cycles for the corresponding clock outputs.
```

```verilog
module freq_div(
    input CLK_in,  // Input clock signal
    input RST,     // Reset signal
    output reg CLK_50,  // Output clock signal with a frequency of CLK_in divided by 2
    output reg CLK_10,  // Output clock signal with a frequency of CLK_in divided by 10
    output reg CLK_1   // Output clock signal with a frequency of CLK_in divided by 100
);

reg [1:0] cnt_2;  // counter for CLK_50
reg [2:0] cnt_10;  // counter for CLK_10
reg [5:0] cnt_100;  // counter for CLK_1

always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        CLK_50 <= 0;
        CLK_10 <= 0;
        CLK_1  <= 0;
        cnt_10 <= 0;
        cnt_100 <= 0;
    end else begin
        // Generate CLK_50 by toggling its current value
        CLK_50 <= ~CLK_50;

        // Generate CLK_10
        if (cnt_10 == 4) begin
            CLK_10 <= ~CLK_10;
            cnt_10 <= 0;
        end else begin
            cnt_10 <= cnt_10 + 1;
        end

        // Generate CLK_1
        if (cnt_100 == 49) begin
            CLK_1 <= ~CLK_1;
            cnt_100 <= 0;
        end else begin
            cnt_100 <= cnt_100 + 1;
        end
    end
end

endmodule
```

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
