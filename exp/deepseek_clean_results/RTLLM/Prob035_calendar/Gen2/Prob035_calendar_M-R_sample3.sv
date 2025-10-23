module calendar (
    input CLK,
    input RST,
    output reg [5:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

// Rollover and enable signals
wire sec_rollover = (Secs == 6'd59);
wire min_rollover = (Mins == 6'd59) & sec_rollover;
wire hour_rollover = (Hours == 6'd23) & min_rollover;

wire min_enable = sec_rollover;
wire hour_enable = min_rollover;

// Seconds counter
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 6'd0;
    end else if (sec_rollover) begin
        Secs <= 6'd0;
    end else begin
        Secs <= Secs + 6'd1;
    end
end

// Minutes counter
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Mins <= 6'd0;
    end else if (min_enable) begin
        if (min_rollover) begin
            Mins <= 6'd0;
        end else begin
            Mins <= Mins + 6'd1;
        end
    end
end

// Hours counter
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Hours <= 6'd0;
    end else if (hour_enable) begin
        if (hour_rollover) begin
            Hours <= 6'd0;
        end else begin
            Hours <= Hours + 6'd1;
        end
    end
end

endmodule