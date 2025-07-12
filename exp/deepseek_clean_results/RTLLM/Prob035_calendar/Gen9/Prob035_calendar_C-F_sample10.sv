module calendar (
    input CLK,
    input RST,
    output reg [4:0] Hours,  // 0-23 (5 bits)
    output reg [5:0] Mins,   // 0-59 (6 bits)
    output reg [5:0] Secs    // 0-59 (6 bits)
);

// Next state calculations
wire sec_rollover = (Secs == 6'd59);
wire min_rollover = (Mins == 6'd59) && sec_rollover;
wire hour_rollover = (Hours == 5'd23) && min_rollover;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        // Synchronous reset
        Hours <= 5'd0;
        Mins <= 6'd0;
        Secs <= 6'd0;
    end else begin
        // Seconds update (always increments unless rolling over)
        Secs <= sec_rollover ? 6'd0 : Secs + 6'd1;
        
        // Minutes update (only when seconds roll over)
        if (sec_rollover) begin
            Mins <= min_rollover ? 6'd0 : Mins + 6'd1;
        end
        
        // Hours update (only when minutes roll over)
        if (min_rollover) begin
            Hours <= hour_rollover ? 5'd0 : Hours + 5'd1;
        end
    end
end

endmodule