module calendar (
    input CLK,
    input RST,
    output reg [4:0] Hours,  // 0-23 (5 bits)
    output reg [5:0] Mins,   // 0-59 (6 bits)
    output reg [5:0] Secs    // 0-59 (6 bits)
);

localparam MAX_SEC = 6'd59;
localparam MAX_MIN = 6'd59;
localparam MAX_HOUR = 5'd23;

// Rollover detection signals
wire sec_rollover = (Secs == MAX_SEC);
wire min_rollover = (Mins == MAX_MIN) && sec_rollover;
wire hour_rollover = (Hours == MAX_HOUR) && min_rollover;

// Clock gating enables
wire min_en = sec_rollover;
wire hour_en = min_rollover;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        // Reset all counters
        Secs <= 6'd0;
        Mins <= 6'd0;
        Hours <= 5'd0;
    end else begin
        // Seconds counter (always increments)
        Secs <= sec_rollover ? 6'd0 : Secs + 6'd1;
        
        // Minutes counter (only on second rollover)
        if (min_en) begin
            Mins <= min_rollover ? 6'd0 : Mins + 6'd1;
        end
        
        // Hours counter (only on minute rollover)
        if (hour_en) begin
            Hours <= hour_rollover ? 5'd0 : Hours + 5'd1;
        end
    end
end

endmodule