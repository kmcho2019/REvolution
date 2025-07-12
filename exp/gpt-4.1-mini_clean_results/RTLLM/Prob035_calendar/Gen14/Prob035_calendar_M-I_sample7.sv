module calendar (
    input  wire       CLK,
    input  wire       RST,
    output reg  [5:0] Secs,  // 0-59
    output reg  [5:0] Mins,  // 0-59
    output reg  [5:0] Hours  // 0-23 (6 bits used for simplicity)
);

wire secs_rollover = (Secs == 6'd59);
wire mins_rollover = (Mins == 6'd59);
wire hours_rollover = (Hours == 6'd23);

always @(posedge CLK or posedge RST) begin
    if (RST)
        Secs <= 6'd0;
    else if (Secs == 6'd59)
        Secs <= 6'd0;
    else
        Secs <= Secs + 6'd1;
end

always @(posedge CLK or posedge RST) begin
    if (RST)
        Mins <= 6'd0;
    else if (secs_rollover) begin
        if (mins_rollover)
            Mins <= 6'd0;
        else
            Mins <= Mins + 6'd1;
    end else
        Mins <= Mins;
end

always @(posedge CLK or posedge RST) begin
    if (RST)
        Hours <= 6'd0;
    else if (secs_rollover && mins_rollover) begin
        if (hours_rollover)
            Hours <= 6'd0;
        else
            Hours <= Hours + 6'd1;
    end else
        Hours <= Hours;
end

endmodule