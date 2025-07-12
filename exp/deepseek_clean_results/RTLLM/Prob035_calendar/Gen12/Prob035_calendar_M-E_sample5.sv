module calendar (
    input CLK,
    input RST,
    output reg [5:0] Hours,  // 6 bits for 0-23 (simpler implementation)
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

// Parameterized time limits
parameter SEC_MAX = 6'd59;
parameter MIN_MAX = 6'd59;
parameter HOUR_MAX = 6'd23;

// Rollover signals (registered one cycle early)
reg sec_roll_next;
reg min_roll_next;
reg hour_roll_next;

// Enable signals for counters
wire sec_en = 1'b1;  // Always counting
wire min_en = sec_roll_next;
wire hour_en = min_roll_next;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        // Reset all counters
        Secs <= 6'd0;
        Mins <= 6'd0;
        Hours <= 6'd0;
        
        // Reset rollover predictions
        sec_roll_next <= 1'b0;
        min_roll_next <= 1'b0;
        hour_roll_next <= 1'b0;
    end else begin
        // Update seconds with rollover
        if (sec_en) begin
            Secs <= (Secs == SEC_MAX) ? 6'd0 : Secs + 6'd1;
        end
        
        // Update minutes when enabled
        if (min_en) begin
            Mins <= (Mins == MIN_MAX) ? 6'd0 : Mins + 6'd1;
        end
        
        // Update hours when enabled
        if (hour_en) begin
            Hours <= (Hours == HOUR_MAX) ? 6'd0 : Hours + 6'd1;
        end
        
        // Pre-compute next cycle's rollover conditions
        sec_roll_next <= (Secs == SEC_MAX - 1);
        min_roll_next <= sec_roll_next && (Mins == MIN_MAX - 1);
        hour_roll_next <= min_roll_next && (Hours == HOUR_MAX - 1);
    end
end

endmodule