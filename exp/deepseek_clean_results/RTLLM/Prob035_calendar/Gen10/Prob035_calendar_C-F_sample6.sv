module calendar (
    input CLK,
    input RST,
    output reg [4:0] Hours,  // 0-23 (5 bits)
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

localparam MAX_SEC_MIN = 6'd59;
localparam MAX_HOUR = 5'd23;

// Rollover signals
wire sec_max = (Secs == MAX_SEC_MIN);
wire min_max = (Mins == MAX_SEC_MIN);
wire hour_max = (Hours == MAX_HOUR);

// Enable signals
wire min_en = sec_max;
wire hour_en = sec_max & min_max;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs <= 6'd0;
        Mins <= 6'd0;
        Hours <= 5'd0;
    end else begin
        // Seconds counter with optimized increment
        Secs <= sec_max ? 6'd0 : Secs + 1;
        
        // Minutes counter with enable
        if (min_en) begin
            Mins <= min_max ? 6'd0 : Mins + 1;
        end
        
        // Hours counter with enable
        if (hour_en) begin
            Hours <= hour_max ? 5'd0 : Hours + 1;
        end
    end
end

endmodule