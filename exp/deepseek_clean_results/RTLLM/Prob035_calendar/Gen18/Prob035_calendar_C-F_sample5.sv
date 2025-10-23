module calendar (
    input CLK,
    input RST,
    output reg [5:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

// Internal hours stored in 5 bits
reg [4:0] hours_int;

// Clock-gated rollover flags
wire sec_rollover = (Secs == 6'd59);
wire min_rollover = sec_rollover && (Mins == 6'd59);
wire hour_rollover = min_rollover && (hours_int == 5'd23);

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 6'd0;
        Mins <= 6'd0;
        hours_int <= 5'd0;
        Hours <= 6'd0;  // Zero-extended output
    end else begin
        // Seconds counter
        Secs <= sec_rollover ? 6'd0 : Secs + 6'd1;
        
        // Minutes counter (only updates when seconds roll over)
        if (sec_rollover) begin
            Mins <= min_rollover ? 6'd0 : Mins + 6'd1;
        end
        
        // Hours counter (only updates when minutes and seconds roll over)
        if (min_rollover) begin
            hours_int <= hour_rollover ? 5'd0 : hours_int + 5'd1;
            Hours <= {1'b0, hour_rollover ? 5'd0 : hours_int + 5'd1};
        end
    end
end

endmodule