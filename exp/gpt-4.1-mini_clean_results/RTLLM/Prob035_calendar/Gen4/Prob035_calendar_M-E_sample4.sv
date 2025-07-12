module calendar (
    input  wire       CLK,
    input  wire       RST,
    output reg  [5:0] Hours,
    output reg  [5:0] Mins,
    output reg  [5:0] Secs
);

// Signals indicating rollovers for chaining increments
wire sec_rollover;
wire min_rollover;

// Seconds counter
always @(posedge CLK) begin
    if (RST) begin
        Secs <= 6'd0;
    end else begin
        if (Secs == 6'd59)
            Secs <= 6'd0;
        else
            Secs <= Secs + 6'd1;
    end
end

assign sec_rollover = (Secs == 6'd59);

// Minutes counter
always @(posedge CLK) begin
    if (RST) begin
        Mins <= 6'd0;
    end else if (sec_rollover) begin
        if (Mins == 6'd59)
            Mins <= 6'd0;
        else
            Mins <= Mins + 6'd1;
    end
end

assign min_rollover = (Mins == 6'd59) & sec_rollover;

// Hours counter
always @(posedge CLK) begin
    if (RST) begin
        Hours <= 6'd0;
    end else if (min_rollover) begin
        if (Hours == 6'd23)
            Hours <= 6'd0;
        else
            Hours <= Hours + 6'd1;
    end
end

endmodule