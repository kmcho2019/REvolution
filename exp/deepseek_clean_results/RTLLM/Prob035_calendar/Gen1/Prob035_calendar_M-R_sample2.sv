module calendar(
    input CLK,
    input RST,
    output reg [4:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

wire min_sec_rollover = (Secs == 6'd59);
wire hour_rollover = (Mins == 6'd59) & min_sec_rollover;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Hours <= 5'd0;
        Mins <= 6'd0;
        Secs <= 6'd0;
    end else begin
        // Seconds counter
        Secs <= (Secs == 6'd59) ? 6'd0 : (Secs + 6'd1);
        
        // Minutes counter
        Mins <= hour_rollover ? 6'd0 : 
               (min_sec_rollover ? (Mins + 6'd1) : Mins);
        
        // Hours counter
        Hours <= (Hours == 5'd23) & hour_rollover ? 5'd0 :
                (hour_rollover ? (Hours + 5'd1) : Hours);
    end
end

endmodule