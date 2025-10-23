module calendar (
    input CLK,
    input RST,
    output reg [4:0] Hours,  // 0-23 (5 bits)
    output reg [5:0] Mins,   // 0-59 (6 bits)
    output reg [5:0] Secs    // 0-59 (6 bits)
);

wire sec_rollover = (Secs == 6'd59);
wire min_rollover = (Mins == 6'd59) & sec_rollover;
wire hour_rollover = (Hours == 5'd23) & min_rollover;

// Seconds counter
always @(posedge CLK) begin
    if (RST)
        Secs <= 6'd0;
    else if (sec_rollover)
        Secs <= 6'd0;
    else
        Secs <= Secs + 6'd1;
end

// Minutes counter
always @(posedge CLK) begin
    if (RST)
        Mins <= 6'd0;
    else if (min_rollover)
        Mins <= 6'd0;
    else if (sec_rollover)
        Mins <= Mins + 6'd1;
end

// Hours counter
always @(posedge CLK) begin
    if (RST)
        Hours <= 5'd0;
    else if (hour_rollover)
        Hours <= 5'd0;
    else if (min_rollover)
        Hours <= Hours + 5'd1;
end

endmodule