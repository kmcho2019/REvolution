module calendar (
    input CLK,
    input RST,
    output reg [4:0] Hours,  // 5 bits for 0-23
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

// Parameterized constants
parameter SEC_MAX = 6'd59;
parameter MIN_MAX = 6'd59;
parameter HOUR_MAX = 5'd23;

always @(posedge CLK or posedge RST) begin
    // Rollover conditions
    wire sec_roll = (Secs == SEC_MAX);
    wire min_roll = (Mins == MIN_MAX) && sec_roll;
    wire hour_roll = (Hours == HOUR_MAX) && min_roll;

    if (RST) begin
        // Synchronous reset
        Hours <= 5'd0;
        Mins <= 6'd0;
        Secs <= 6'd0;
    end else begin
        // Seconds update
        Secs <= sec_roll ? 6'd0 : Secs + 6'd1;
        
        // Minutes update (only when seconds roll over)
        Mins <= sec_roll ? (min_roll ? 6'd0 : Mins + 6'd1) : Mins;
        
        // Hours update (only when minutes roll over)
        Hours <= min_roll ? (hour_roll ? 5'd0 : Hours + 5'd1) : Hours;
    end
end

endmodule