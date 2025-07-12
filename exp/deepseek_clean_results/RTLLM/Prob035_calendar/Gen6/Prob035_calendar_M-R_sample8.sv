module calendar(
    input CLK,
    input RST,
    output reg [4:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

localparam MAX_SEC = 6'd59;
localparam MAX_MIN = 6'd59;
localparam MAX_HOUR = 5'd23;

wire sec_rollover = (Secs == MAX_SEC);
wire min_rollover = (Mins == MAX_MIN);
wire hour_rollover = (Hours == MAX_HOUR);

wire min_enable = sec_rollover;
wire hour_enable = sec_rollover & min_rollover;

// Seconds counter
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 6'd0;
    end else begin
        Secs <= sec_rollover ? 6'd0 : Secs + 6'd1;
    end
end

// Minutes counter
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Mins <= 6'd0;
    end else if (min_enable) begin
        Mins <= min_rollover ? 6'd0 : Mins + 6'd1;
    end
end

// Hours counter
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Hours <= 5'd0;
    end else if (hour_enable) begin
        Hours <= hour_rollover ? 5'd0 : Hours + 5'd1;
    end
end

endmodule