module calendar (
    input CLK,
    input RST,
    output reg [5:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

// Continuous assignments for rollover conditions
wire sec_rollover = (Secs == 6'd59);
wire min_rollover = (Mins == 6'd59) & sec_rollover;
wire hour_rollover = (Hours[4:0] == 5'd23) & min_rollover;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 6'd0;
        Mins <= 6'd0;
        Hours <= 6'd0;
    end else begin
        // Update seconds with rollover
        Secs <= sec_rollover ? 6'd0 : Secs + 1;
        
        // Update minutes only when seconds roll over
        Mins <= sec_rollover ? 
               (min_rollover ? 6'd0 : Mins + 1) : 
               Mins;
               
        // Update hours only when minutes and seconds roll over
        Hours <= (sec_rollover & min_rollover) ? 
                {1'b0, (hour_rollover ? 5'd0 : Hours[4:0] + 1)} : 
                Hours;
    end
end

endmodule