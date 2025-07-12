module calendar (
    input CLK,
    input RST,
    output reg [5:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

parameter MAX_SEC = 6'd59;
parameter MAX_MIN = 6'd59;
parameter MAX_HOUR = 5'd23;

reg sec_rollover;
reg min_rollover;
reg hour_rollover;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 6'd0;
        Mins <= 6'd0;
        Hours <= 6'd0;
        sec_rollover <= 1'b0;
        min_rollover <= 1'b0;
        hour_rollover <= 1'b0;
    end else begin
        // Pre-calculate rollover conditions (registered for better timing)
        sec_rollover <= (Secs == MAX_SEC);
        min_rollover <= (Mins == MAX_MIN) & sec_rollover;
        hour_rollover <= (Hours[4:0] == MAX_HOUR) & min_rollover;

        // Seconds counter (always updates)
        Secs <= sec_rollover ? 6'd0 : Secs + 6'd1;
        
        // Minutes counter (only updates when seconds roll over)
        if (sec_rollover) begin
            Mins <= min_rollover ? 6'd0 : Mins + 6'd1;
        end
        
        // Hours counter (only updates when minutes roll over)
        if (min_rollover) begin
            Hours <= {1'b0, hour_rollover ? 5'd0 : (Hours[4:0] + 5'd1)};
        end
    end
end

endmodule