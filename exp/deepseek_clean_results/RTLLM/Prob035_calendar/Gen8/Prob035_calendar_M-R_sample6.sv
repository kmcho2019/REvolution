module calendar (
    input CLK,
    input RST,
    output reg [4:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

// Enable signals
wire sec_en = 1'b1;  // Always counting
wire min_en = (Secs == 6'd59);
wire hour_en = (Secs == 6'd59) && (Mins == 6'd59);

// Rollover conditions
wire sec_roll = (Secs == 6'd59);
wire min_roll = (Mins == 6'd59);
wire hour_roll = (Hours == 5'd23);

// Seconds counter
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 6'd0;
    end else if (sec_en) begin
        Secs <= sec_roll ? 6'd0 : Secs + 6'd1;
    end
end

// Minutes counter
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Mins <= 6'd0;
    end else if (min_en) begin
        Mins <= min_roll ? 6'd0 : Mins + 6'd1;
    end
end

// Hours counter
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Hours <= 5'd0;
    end else if (hour_en) begin
        Hours <= hour_roll ? 5'd0 : Hours + 5'd1;
    end
end

endmodule