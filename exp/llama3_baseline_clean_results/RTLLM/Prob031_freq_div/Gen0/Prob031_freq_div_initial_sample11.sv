```thought
To solve this problem, we can design a Verilog module named `freq_div` that takes an input clock signal `CLK_in` and a reset signal `RST`, and generates three output clock signals `CLK_50`, `CLK_10`, and `CLK_1` with frequencies of 50MHz, 10MHz, and 1MHz respectively. The module will use counters to divide the input clock frequency. For `CLK_50`, we simply toggle the signal on every positive edge of `CLK_in`. For `CLK_10` and `CLK_1`, we use counters `cnt_10` and `cnt_100` to generate the divided frequencies.
```

```verilog
module freq_div(
    input CLK_in,
    input RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

reg [1:0] cnt_10;
reg [5:0] cnt_100;

always @(posedge CLK_in or posedge RST) begin
    if(RST) begin
        CLK_50 <= 0;
        CLK_10 <= 0;
        CLK_1 <= 0;
        cnt_10 <= 0;
        cnt_100 <= 0;
    end else begin
        // Generate CLK_50
        CLK_50 <= ~CLK_50;
        
        // Generate CLK_10
        if(cnt_10 == 4) begin
            CLK_10 <= ~CLK_10;
            cnt_10 <= 0;
        end else begin
            cnt_10 <= cnt_10 + 1;
        end
        
        // Generate CLK_1
        if(cnt_100 == 49) begin
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
