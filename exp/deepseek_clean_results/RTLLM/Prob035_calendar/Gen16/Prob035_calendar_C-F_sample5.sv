module calendar (
    input CLK,
    input RST,
    output reg [5:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

localparam MAX_SEC_MIN = 6'd59;
localparam MAX_HOUR = 6'd23;

// Rollover conditions
wire sec_rollover = (Secs == MAX_SEC_MIN);
wire min_rollover = (Mins == MAX_SEC_MIN) & sec_rollover;
wire hour_rollover = (Hours == MAX_HOUR) & min_rollover;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 6'd0;
        Mins <= 6'd0;
        Hours <= 6'd0;
    end else begin
        // Seconds counter with enable-like condition
        if (sec_rollover)
            Secs <= 6'd0;
        else
            Secs <= Secs + 6'd1;
        
        // Minutes counter (only updates when seconds roll over)
        if (sec_rollover) begin
            if (min_rollover)
                Mins <= 6'd0;
            else
                Mins <= Mins + 6'd1;
        end
        
        // Hours counter (only updates when minutes and seconds roll over)
        if (min_rollover) begin
            if (hour_rollover)
                Hours <= 6'd0;
            else
                Hours <= Hours + 6'd1;
        end
    end
end

endmodule