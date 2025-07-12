module calendar (
    input CLK,
    input RST,
    output reg [4:0] Hours,  // 0-23 (5 bits)
    output reg [5:0] Mins,    // 0-59 (6 bits)
    output reg [5:0] Secs     // 0-59 (6 bits)
);

// Constants
localparam MAX_SEC = 6'd59;
localparam MAX_MIN = 6'd59;
localparam MAX_HOUR = 5'd23;

// Rollover signals (parallel evaluation)
wire sec_max = (Secs == MAX_SEC);
wire min_max = (Mins == MAX_MIN);
wire hour_max = (Hours == MAX_HOUR);

// Enable signals for clock gating
wire min_en = sec_max;
wire hour_en = sec_max & min_max;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        // Synchronous reset
        Secs <= 6'd0;
        Mins <= 6'd0;
        Hours <= 5'd0;
    end else begin
        // Seconds counter (always increments)
        Secs <= sec_max ? 6'd0 : Secs + 1'b1;
        
        // Minutes counter (only when seconds roll over)
        if (min_en) begin
            Mins <= min_max ? 6'd0 : Mins + 1'b1;
        end
        
        // Hours counter (only when both seconds and minutes roll over)
        if (hour_en) begin
            Hours <= hour_max ? 5'd0 : Hours + 1'b1;
        end
    end
end

endmodule