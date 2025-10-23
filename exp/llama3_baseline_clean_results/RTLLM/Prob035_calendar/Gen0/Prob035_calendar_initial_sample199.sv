```thought
To implement the perpetual calendar module, we'll use three always blocks to update the values of seconds, minutes, and hours based on the clock signal and reset signal. Each block will trigger on the positive edge of the clock signal or the positive edge of the reset signal. We'll use conditional statements to check for wrap-around conditions and reset the values accordingly.
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
    end else begin
        Mins <= Mins;
    end
end

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Hours <= 6'd0;
    end else if (Hours == 6'd23 && Mins == 6'd59 && Secs == 6'd59) begin
        Hours <= 6'd0;
    end else if (Mins == 6'd59 && Secs == 6'd59) begin
        Hours <= Hours + 6'd1;
    end else begin
        Hours <= Hours;
    end
end

endmodule
```

This code defines a perpetual calendar module with three output ports: `Hours`, `Mins`, and `Secs`, which represent the current hours, minutes, and seconds, respectively. The `CLK` input port represents the clock signal, and the `RST` input port represents the active high reset signal. The module uses three always blocks to update the values of `Secs`, `Mins`, and `Hours` based on the clock signal and reset signal. Each block triggers on the positive edge of the clock signal or the positive edge of the reset signal and uses conditional statements to check for wrap-around conditions and reset the values accordingly.

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
