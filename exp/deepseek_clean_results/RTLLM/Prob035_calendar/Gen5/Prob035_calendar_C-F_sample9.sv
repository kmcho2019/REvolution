module calendar (
    input CLK,
    input RST,
    output reg [5:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

// Constants for readability and easy modification
parameter SEC_MAX = 6'd59;
parameter MIN_MAX = 6'd59;
parameter HOUR_MAX = 6'd23;

// Rollover conditions
wire sec_rollover = (Secs == SEC_MAX);
wire min_rollover = (Mins == MIN_MAX) & sec_rollover;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Hours <= 6'd0;
        Mins <= 6'd0;
        Secs <= 6'd0;
    end else begin
        // Always update seconds
        Secs <= sec_rollover ? 6'd0 : Secs + 6'd1;
        
        // Update minutes only when seconds roll over
        if (sec_rollover) begin
            Mins <= min_rollover ? 6'd0 : Mins + 6'd1;
            
            // Update hours only when both minutes and seconds roll over
            if (min_rollover) begin
                Hours <= (Hours == HOUR_MAX) ? 6'd0 : Hours + 6'd1;
            end
        end
    end
end

endmodule