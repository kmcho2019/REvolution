module calendar (
    input CLK,
    input RST,
    output reg [5:0] Hours,
    output reg [5:0] Mins,
    output reg [5:0] Secs
);

// Parameters for easy modification
parameter SEC_MAX = 6'd59;
parameter MIN_MAX = 6'd59;
parameter HOUR_MAX = 5'd23;

// Internal signals
wire sec_en = 1'b1;  // Seconds always increment
wire min_en = (Secs == SEC_MAX);
wire hour_en = (Mins == MIN_MAX) & min_en;

// Combined next state logic
always @(posedge CLK) begin
    if (RST) begin
        Secs <= 6'd0;
        Mins <= 6'd0;
        Hours <= 6'd0;
    end else begin
        // Seconds counter (always increments)
        if (sec_en) begin
            Secs <= (Secs == SEC_MAX) ? 6'd0 : Secs + 1'b1;
        end

        // Minutes counter (only when seconds roll over)
        if (min_en) begin
            Mins <= (Mins == MIN_MAX) ? 6'd0 : Mins + 1'b1;
        end

        // Hours counter (only when minutes and seconds roll over)
        if (hour_en) begin
            Hours <= (Hours[4:0] == HOUR_MAX) ? 6'd0 : {1'b0, Hours[4:0]} + 1'b1;
        end
    end
end

endmodule