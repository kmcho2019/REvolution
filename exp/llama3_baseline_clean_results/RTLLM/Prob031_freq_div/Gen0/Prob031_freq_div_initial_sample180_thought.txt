```thought
To design the frequency divider module `freq_div`, we will use three counters to divide the input clock frequency. 
For CLK_50, we can simply toggle its value on every positive edge of CLK_in. 
For CLK_10 and CLK_1, we will use counters cnt_10 and cnt_100, respectively, to keep track of the number of cycles. 
When these counters reach their respective thresholds (4 for CLK_10 and 49 for CLK_1), we toggle the corresponding clock signals and reset the counters.
We will also handle the reset logic for each clock signal when RST is active.
```

```verilog
module freq_div(CLK_in, RST, CLK_50, CLK_10, CLK_1);
    input CLK_in;
    input RST;
    output reg CLK_50;
    output reg CLK_10;
    output reg CLK_1;
    reg [1:0] cnt_10;
    reg [5:0] cnt_100;

    always @(posedge CLK_in or posedge RST) begin
        if(RST) begin
            CLK_50 <= 0;
            CLK_10 <= 0;
            CLK_1 <= 0;
            cnt_10 <= 0;
            cnt_100 <= 0;
        end
        else begin
            CLK_50 <= ~CLK_50;

            cnt_10 <= cnt_10 + 1;
            if(cnt_10 == 4) begin
                cnt_10 <= 0;
                CLK_10 <= ~CLK_10;
            end

            cnt_100 <= cnt_100 + 1;
            if(cnt_100 == 49) begin
                cnt_100 <= 0;
                CLK_1 <= ~CLK_1;
            end
        end
    end
endmodule
```

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
