```thought
The design involves creating a Verilog module named `freq_div` that takes in an input clock signal `CLK_in` and a reset signal `RST`, and generates three output clock signals: `CLK_50`, `CLK_10`, and `CLK_1` with frequencies of 50MHz, 10MHz, and 1MHz respectively. The module will utilize counters to achieve the desired frequency divisions. 
The generation of `CLK_50` will be based on a simple toggle operation on every positive edge of `CLK_in` or `RST`. 
For `CLK_10` and `CLK_1`, counters `cnt_10` and `cnt_100` will be used to divide the input clock frequency by 10 and 100 respectively.
The counters will be reset to 0 when `RST` is active.
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
        cnt_10 <= 0;
        cnt_100 <= 0;
        CLK_1 <= 0;
    end else begin
        CLK_50 <= ~CLK_50; // Toggle CLK_50 on every positive edge of CLK_in

        if(cnt_10 == 4) begin
            cnt_10 <= 0; // Reset counter
            CLK_10 <= ~CLK_10; // Toggle CLK_10
        end else begin
            cnt_10 <= cnt_10 + 1; // Increment counter
        end

        if(cnt_100 == 49) begin
            cnt_100 <= 0; // Reset counter
            CLK_1 <= ~CLK_1; // Toggle CLK_1
        end else begin
            cnt_100 <= cnt_100 + 1; // Increment counter
        end
    end
end

endmodule
```

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
