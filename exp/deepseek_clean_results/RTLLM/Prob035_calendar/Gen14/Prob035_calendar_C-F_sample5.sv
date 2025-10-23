module calendar (
    input CLK,
    input RST,
    output reg [5:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

// Internal representation (5 bits sufficient for 0-23)
reg [4:0] hours_int;

// Rollover flags
wire sec_max = (Secs == 6'd59);
wire min_max = (Mins == 6'd59);
wire hour_max = (hours_int == 5'd23);

// Enable signals
wire min_en = sec_max;
wire hour_en = sec_max & min_max;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 6'd0;
        Mins <= 6'd0;
        hours_int <= 5'd0;
    end else begin
        // Seconds counter (always increments)
        Secs <= sec_max ? 6'd0 : Secs + 6'd1;
        
        // Minutes counter (only when seconds roll over)
        if (min_en) begin
            Mins <= min_max ? 6'd0 : Mins + 6'd1;
        end
        
        // Hours counter (only when minutes and seconds roll over)
        if (hour_en) begin
            hours_int <= hour_max ? 5'd0 : hours_int + 5'd1;
        end
    end
end

// Zero-extend hours_int to 6-bit output
always @(*) begin
    Hours = {1'b0, hours_int};
end

endmodule