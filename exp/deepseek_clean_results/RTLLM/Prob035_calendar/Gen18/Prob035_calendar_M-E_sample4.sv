module calendar (
    input CLK,
    input RST,
    output reg [5:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

// Next state signals
reg [5:0] next_sec, next_min, next_hour;

// Predictive rollover detection (combinatorial)
wire sec_max = (Secs == 6'd59);
wire min_max = (Mins == 6'd59);
wire hour_max = (Hours == 6'd23);

always @(*) begin
    // Default next states (hold current values)
    next_sec = Secs;
    next_min = Mins;
    next_hour = Hours;

    // Reset condition takes priority
    if (RST) begin
        next_sec = 6'd0;
        next_min = 6'd0;
        next_hour = 6'd0;
    end
    else begin
        // Always increment seconds
        next_sec = sec_max ? 6'd0 : Secs + 6'd1;

        // Minute update depends on second rollover
        if (sec_max) begin
            next_min = min_max ? 6'd0 : Mins + 6'd1;
        end

        // Hour update depends on both rollovers
        if (sec_max & min_max) begin
            next_hour = hour_max ? 6'd0 : Hours + 6'd1;
        end
    end
end

// Sequential update block
always @(posedge CLK) begin
    Secs <= next_sec;
    Mins <= next_min;
    Hours <= next_hour;
end

endmodule