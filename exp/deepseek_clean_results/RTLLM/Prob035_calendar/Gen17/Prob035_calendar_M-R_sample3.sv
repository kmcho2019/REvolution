module calendar (
    input CLK,
    input RST,
    output reg [5:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

// Continuous rollover detection
wire sec_max = (Secs == 6'd59);
wire min_max = (Mins == 6'd59) & sec_max;
wire hour_max = (Hours[4:0] == 5'd23) & min_max;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 6'd0;
        Mins <= 6'd0;
        Hours <= 6'd0;
    end else begin
        // Update seconds
        Secs <= sec_max ? 6'd0 : Secs + 1;
        
        // Update minutes (only when seconds roll over)
        Mins <= sec_max ? (min_max ? 6'd0 : Mins + 1) : Mins;
        
        // Update hours (only when minutes and seconds roll over)
        Hours <= min_max ? 
                 (hour_max ? {1'b0, 5'd0} : {1'b0, Hours[4:0] + 1}) : 
                 Hours;
    end
end

endmodule