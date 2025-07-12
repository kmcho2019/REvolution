module calendar (
    input  wire       CLK,
    input  wire       RST,
    output reg  [4:0] Hours, // 0-23 requires 5 bits
    output reg  [5:0] Mins,  // 0-59 requires 6 bits
    output reg  [5:0] Secs   // 0-59 requires 6 bits
);

    // Parameters defining max values for counters
    localparam HOURS_MAX = 5'd23;
    localparam MINS_MAX  = 6'd59;
    localparam SECS_MAX  = 6'd59;

    // Internal signal indicating seconds rollover (Secs == SECS_MAX)
    wire sec_rollover = (Secs == SECS_MAX);

    // Seconds counter: increments every clock cycle, wraps from 59 to 0
    always @(posedge CLK or posedge RST) begin
        if (RST)
            Secs <= 6'd0;
        else if (Secs == SECS_MAX)
            Secs <= 6'd0;
        else
            Secs <= Secs + 6'd1;
    end

    // Minutes counter: increments only when seconds roll over; wraps from 59 to 0
    always @(posedge CLK or posedge RST) begin
        if (RST)
            Mins <= 6'd0;
        else if (sec_rollover) begin
            if (Mins == MINS_MAX)
                Mins <= 6'd0;
            else
                Mins <= Mins + 6'd1;
        end
        // No else assignment for power optimization
    end

    // Hours counter: increments only when minutes and seconds roll over; wraps from 23 to 0
    always @(posedge CLK or posedge RST) begin
        if (RST)
            Hours <= 5'd0;
        else if (sec_rollover) begin
            if (Mins == MINS_MAX) begin
                if (Hours == HOURS_MAX)
                    Hours <= 5'd0;
                else
                    Hours <= Hours + 5'd1;
            end
            // else no change
        end
        // No else assignment for power optimization
    end

endmodule