module calendar (
    input  wire       CLK,
    input  wire       RST,
    output reg  [4:0] Hours, // 0-23 requires 5 bits
    output reg  [5:0] Mins,
    output reg  [5:0] Secs
);

    wire secs_rollover = (Secs == 6'd59);
    wire mins_rollover = (Mins == 6'd59) && secs_rollover;
    wire hours_rollover = (Hours == 5'd23) && mins_rollover;

    // Seconds counter: increments every clock, wraps at 59 -> 0
    always @(posedge CLK or posedge RST) begin
        if (RST)
            Secs <= 6'd0;
        else if (secs_rollover)
            Secs <= 6'd0;
        else
            Secs <= Secs + 6'd1;
    end

    // Minutes counter: increments only when seconds roll over, wraps at 59 -> 0
    always @(posedge CLK or posedge RST) begin
        if (RST)
            Mins <= 6'd0;
        else if (mins_rollover)
            Mins <= 6'd0;
        else if (secs_rollover)
            Mins <= Mins + 6'd1;
        // no else branch for optimization
    end

    // Hours counter: increments only when minutes and seconds roll over, wraps at 23 -> 0
    always @(posedge CLK or posedge RST) begin
        if (RST)
            Hours <= 5'd0;
        else if (hours_rollover)
            Hours <= 5'd0;
        else if (mins_rollover)
            Hours <= Hours + 5'd1;
        // no else branch for optimization
    end

endmodule