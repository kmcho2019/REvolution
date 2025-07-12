module calendar (
    input  wire       CLK,
    input  wire       RST,
    output reg  [4:0] Hours, // 0-23 requires 5 bits
    output reg  [5:0] Mins,  // 0-59 requires 6 bits
    output reg  [5:0] Secs   // 0-59 requires 6 bits
);

    // Local variables to hold next state values
    reg [5:0] next_secs;
    reg [5:0] next_mins;
    reg [4:0] next_hours;

    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            // Asynchronous reset: initialize all counters to zero
            Secs  <= 6'd0;
            Mins  <= 6'd0;
            Hours <= 5'd0;
        end else begin
            // Determine next second count
            if (Secs == 6'd59) begin
                next_secs = 6'd0;

                // Determine next minute count on second rollover
                if (Mins == 6'd59) begin
                    next_mins = 6'd0;

                    // Determine next hour count on minute rollover
                    if (Hours == 5'd23) begin
                        next_hours = 5'd0;
                    end else begin
                        next_hours = Hours + 5'd1;
                    end
                end else begin
                    next_mins = Mins + 6'd1;
                    next_hours = Hours; // No hour increment
                end
            end else begin
                next_secs = Secs + 6'd1;
                next_mins = Mins;   // No minute increment
                next_hours = Hours; // No hour increment
            end

            // Update registers only if their values have changed to reduce unnecessary toggling
            if (Secs != next_secs)
                Secs <= next_secs;
            if (Mins != next_mins)
                Mins <= next_mins;
            if (Hours != next_hours)
                Hours <= next_hours;
        end
    end

endmodule