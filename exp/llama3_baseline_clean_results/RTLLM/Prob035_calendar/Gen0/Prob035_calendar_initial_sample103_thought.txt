```thought
The perpetual calendar module can be designed using three always blocks that update the seconds, minutes, and hours values based on the clock signal and reset signal. Each always block checks for the reset condition and the wrap-around conditions for the seconds, minutes, and hours values. The seconds value is incremented every clock cycle, and when it reaches 59, the minutes value is incremented. Similarly, when the minutes value reaches 59 and the seconds value is 59, the hours value is incremented. The hours value wraps around from 23 to 0.
```

```verilog
module calendar(
    input CLK,
    input RST,
    output reg [5:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 6'd0;
    end else if (Secs == 6'd59) begin
        Secs <= 6'd0;
    end else begin
        Secs <= Secs + 6'd1;
    end
end

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Mins <= 6'd0;
    end else if (Mins == 6'd59 && Secs == 6'd59) begin
        Mins <= 6'd0;
    end else if (Secs == 6'd59) begin
        Mins <= Mins + 6'd1;
    end
end

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Hours <= 6'd0;
    end else if (Hours == 6'd23 && Mins == 6'd59 && Secs == 6'd59) begin
        Hours <= 6'd0;
    end else if (Mins == 6'd59 && Secs == 6'd59) begin
        Hours <= Hours + 6'd1;
    end
end

endmodule
```

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
