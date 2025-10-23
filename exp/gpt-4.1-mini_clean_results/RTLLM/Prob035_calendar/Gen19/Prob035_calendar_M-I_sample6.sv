module calendar (
    input  wire       CLK,
    input  wire       RST,
    output reg  [4:0] Hours, // 0-23 requires 5 bits
    output reg  [5:0] Mins,  // 0-59 requires 6 bits
    output reg  [5:0] Secs   // 0-59 requires 6 bits
);

    // Next state signals
    reg [5:0] next_secs;
    reg [5:0] next_mins;
    reg [4:0] next_hours;

    // Clock enables for minutes and hours to reduce unnecessary toggling
    wire secs_rollover;
    wire mins_rollover;

    // Combinational next-state logic block
    always @* begin
        // Default: maintain current values
        next_secs  = Secs;
        next_mins  = Mins;
        next_hours = Hours;

        // Seconds counter logic
        if (Secs == 6'd59) begin
            next_secs = 6'd0;
            // Minute counter logic on second rollover
            if (Mins == 6'd59) begin
                next_mins = 6'd0;
                // Hour counter logic on minute rollover
                if (Hours == 5'd23) begin
                    next_hours = 5'd0;
                end else begin
                    next_hours = Hours + 5'd1;
                end
            end else begin
                next_mins = Mins + 6'd1;
                // Hours unchanged
            end
        end else begin
            next_secs = Secs + 6'd1;
            // Mins and Hours unchanged
        end
    end

    assign secs_rollover = (Secs == 6'd59);
    assign mins_rollover = secs_rollover && (Mins == 6'd59);

    // Sequential logic: update registers only when enabled or reset
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            Secs  <= 6'd0;
            Mins  <= 6'd0;
            Hours <= 5'd0;
        end else begin
            // Update seconds every cycle
            if (Secs != next_secs) 
                Secs <= next_secs;

            // Update minutes only on seconds rollover
            if (secs_rollover && (Mins != next_mins))
                Mins <= next_mins;

            // Update hours only on minutes rollover
            if (mins_rollover && (Hours != next_hours))
                Hours <= next_hours;
        end
    end

endmodule