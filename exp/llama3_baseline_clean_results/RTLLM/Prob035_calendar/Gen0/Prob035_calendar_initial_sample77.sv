```thought
To implement the perpetual calendar module, we will use three always blocks that trigger on the positive edge of the clock signal (posedge CLK) or the positive edge of the reset signal (posedge RST). Each block will be responsible for updating the values of seconds, minutes, and hours accordingly. We will use conditional statements to check for the reset signal, seconds, minutes, and hours values to determine the next state of the calendar. The seconds and minutes will wrap around to 0 after reaching 59, while the hours will wrap around to 0 after reaching 23.
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
    if(RST) begin
        Secs <= 6'b0;
    end else if(Secs == 6'd59) begin
        Secs <= 6'b0;
    end else begin
        Secs <= Secs + 1;
    end
end

always @(posedge CLK or posedge RST) begin
    if(RST) begin
        Mins <= 6'b0;
    end else if(Mins == 6'd59 && Secs == 6'd59) begin
        Mins <= 6'b0;
    end else if(Secs == 6'd59) begin
        Mins <= Mins + 1;
    end
end

always @(posedge CLK or posedge RST) begin
    if(RST) begin
        Hours <= 6'b0;
    end else if(Hours == 6'd23 && Mins == 6'd59 && Secs == 6'd59) begin
        Hours <= 6'b0;
    end else if(Mins == 6'd59 && Secs == 6'd59) begin
        Hours <= Hours + 1;
    end
end

endmodule
```

This code defines the perpetual calendar module as specified, with the hours, minutes, and seconds updating accordingly based on the clock and reset signals. The seconds and minutes wrap around to 0 after reaching 59, while the hours wrap around to 0 after reaching 23. The module resets to 0 when the reset signal is active.

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
