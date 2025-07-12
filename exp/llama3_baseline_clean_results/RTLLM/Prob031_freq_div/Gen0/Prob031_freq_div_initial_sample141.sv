```thought
To implement the frequency divider, we will create a Verilog module named freq_div with input ports for the clock signal (CLK_in) and the reset signal (RST), and output ports for the divided clock signals (CLK_50, CLK_10, CLK_1). We will use three counters to divide the input clock frequency. The counters will be used to generate the output clock signals with the desired frequencies by toggling their values at specific intervals. We will also implement the reset logic to set the output clock signals and counters to their initial states when the RST signal is active.
```

```verilog
module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

reg [1:0] cnt_2;
reg [2:0] cnt_10;
reg [5:0] cnt_100;

always @ (posedge CLK_in or posedge RST) begin
    if (RST) begin
        CLK_50 <= 1'b0;
        cnt_2 <= 2'b0;
        CLK_10 <= 1'b0;
        cnt_10 <= 3'b0;
        CLK_1 <= 1'b0;
        cnt_100 <= 6'b0;
    end else begin
        // Generate 50 MHz clock signal
        cnt_2 <= cnt_2 + 1'b1;
        if (cnt_2 == 2'b1) begin
            CLK_50 <= ~CLK_50;
            cnt_2 <= 2'b0;
        end

        // Generate 10 MHz clock signal
        cnt_10 <= cnt_10 + 1'b1;
        if (cnt_10 == 4'd9) begin
            CLK_10 <= ~CLK_10;
            cnt_10 <= 3'b0;
        end

        // Generate 1 MHz clock signal
        cnt_100 <= cnt_100 + 1'b1;
        if (cnt_100 == 6'd49) begin
            CLK_1 <= ~CLK_1;
            cnt_100 <= 6'b0;
        end
    end
end

endmodule
```
Note that the counters `cnt_2`, `cnt_10`, and `cnt_100` are used to generate the output clock signals with the desired frequencies by toggling their values at specific intervals. The counter `cnt_2` is used to generate the 50 MHz clock signal, `cnt_10` is used to generate the 10 MHz clock signal, and `cnt_100` is used to generate the 1 MHz clock signal. The reset logic is implemented using the `RST` signal to set the output clock signals and counters to their initial states when `RST` is active.

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
