```thought
The frequency divider module will utilize three counters to generate the desired output frequencies. The module will use a simple toggle approach for the 50MHz clock generation and counter-based approaches for the 10MHz and 1MHz clock generations. 
The toggle approach for 50MHz clock will change the state of the output clock on every positive edge of the input clock, effectively dividing the frequency by 2.
The counter-based approaches for 10MHz and 1MHz clocks will increment their respective counters on every positive edge of the input clock and toggle the output clock when the counter reaches a specific value (4 for 10MHz and 49 for 1MHz), effectively dividing the frequency by the specified ratio.
The reset signal will be used to reset the counters and output clocks to their initial states.
```

```verilog
module freq_div(
    input CLK_in,
    input RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg [3:0] cnt_10,
    output reg [5:0] cnt_100,
    output reg CLK_1
);

// Internal wires
reg CLK_50_int;
reg CLK_10_int;
reg [3:0] cnt_10_int;
reg [5:0] cnt_100_int;
reg CLK_1_int;

always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        // Reset all counters and clocks
        CLK_50_int <= 1'b0;
        CLK_10_int <= 1'b0;
        cnt_10_int <= 4'd0;
        cnt_100_int <= 6'd0;
        CLK_1_int <= 1'b0;
    end else begin
        // Generate 50MHz clock
        CLK_50_int <= ~CLK_50_int;
        
        // Generate 10MHz clock
        if (cnt_10_int == 4'd9) begin
            CLK_10_int <= ~CLK_10_int;
            cnt_10_int <= 4'd0;
        end else begin
            cnt_10_int <= cnt_10_int + 1;
        end
        
        // Generate 1MHz clock
        if (cnt_100_int == 6'd99) begin
            CLK_1_int <= ~CLK_1_int;
            cnt_100_int <= 6'd0;
        end else begin
            cnt_100_int <= cnt_100_int + 1;
        end
    end
end

assign CLK_50 = CLK_50_int;
assign CLK_10 = CLK_10_int;
assign cnt_10 = cnt_10_int;
assign cnt_100 = cnt_100_int;
assign CLK_1 = CLK_1_int;

endmodule
```

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
