module calendar(
    input CLK,
    input RST,
    output reg [5:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

reg hour_enable;
wire sec_rollover = (Secs >= 6'd59);
wire min_rollover = (Mins >= 6'd59) & sec_rollover;

// Seconds and Minutes counter (faster path)
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 6'd0;
        Mins <= 6'd0;
        hour_enable <= 1'b0;
    end else begin
        // Seconds counter
        Secs <= sec_rollover ? 6'd0 : (Secs + 6'd1);
        
        // Minutes counter
        if (sec_rollover) begin
            Mins <= min_rollover ? 6'd0 : (Mins + 6'd1);
        end
        
        // Pre-compute hour enable
        hour_enable <= min_rollover & sec_rollover;
    end
end

// Hours counter (slower path)
always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Hours <= 6'd0;
    end else if (hour_enable) begin
        Hours <= (Hours >= 6'd23) ? 6'd0 : (Hours + 6'd1);
    end
end

endmodule