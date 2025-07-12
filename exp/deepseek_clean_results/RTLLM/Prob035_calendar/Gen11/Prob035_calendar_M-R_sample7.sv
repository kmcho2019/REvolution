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

// Next value calculations
wire [5:0] next_sec = sec_rollover ? 6'd0 : Secs + 6'd1;
wire [5:0] next_min = min_rollover ? 6'd0 : 
                     (sec_rollover ? Mins + 6'd1 : Mins);
wire [5:0] next_hour = hour_rollover ? 6'd0 : 
                      (min_rollover ? {1'b0, Hours[4:0] + 5'd1} : Hours);

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 6'd0;
        Mins <= 6'd0;
        Hours <= 6'd0;
    end else begin
        Secs <= next_sec;
        Mins <= next_min;
        Hours <= next_hour;
    end
end

endmodule