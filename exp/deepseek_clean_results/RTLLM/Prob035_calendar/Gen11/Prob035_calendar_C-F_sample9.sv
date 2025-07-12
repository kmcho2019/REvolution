module calendar (
    input CLK,
    input RST,
    output reg [5:0] Hours,  // 6-bit with MSB=0 (0-23)
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

localparam MAX_SEC = 6'd59;
localparam MAX_MIN = 6'd59;
localparam MAX_HOUR = 5'd23;

// Rollover detection signals
wire sec_rollover = (Secs == MAX_SEC);
wire min_rollover = (Mins == MAX_MIN) && sec_rollover;
wire hour_rollover = (Hours[4:0] == MAX_HOUR) && min_rollover;

// Clock gating enables
wire min_en = sec_rollover;
wire hour_en = min_rollover;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        // Reset all counters
        Secs <= 6'd0;
        Mins <= 6'd0;
        Hours <= 6'd0;
    end else begin
        // Seconds counter (always enabled)
        Secs <= sec_rollover ? 6'd0 : Secs + 6'd1;
        
        // Minutes counter (enabled on second rollover)
        if (min_en) begin
            Mins <= min_rollover ? 6'd0 : Mins + 6'd1;
        end
        
        // Hours counter (enabled on minute rollover)
        if (hour_en) begin
            Hours <= {1'b0, hour_rollover ? 5'd0 : (Hours[4:0] + 5'd1)};
        end
    end
end

endmodule