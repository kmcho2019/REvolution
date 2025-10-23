module calendar (
    input  wire       CLK,
    input  wire       RST,
    output reg  [4:0] Hours,  // 0-23 range requires 5 bits
    output reg  [5:0] Mins,   // 0-59 range requires 6 bits
    output reg  [5:0] Secs    // 0-59 range requires 6 bits
);

    // Parameters for maximum counts for better readability and ease of change
    localparam HOURS_MAX = 5'd23;
    localparam MINS_MAX  = 6'd59;
    localparam SECS_MAX  = 6'd59;

    // Local variables to hold next state values
    reg [5:0] next_secs;
    reg [5:0] next_mins;
    reg [4:0] next_hours;

    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            // Asynchronous reset to zero all counters
            Secs  <= 6'd0;
            Mins  <= 6'd0;
            Hours <= 5'd0;
        end else begin
            // Calculate next second value with rollover
            if (Secs == SECS_MAX) begin
                next_secs = 6'd0;
                // Seconds rolled over, increment minutes
                if (Mins == MINS_MAX) begin
                    next_mins = 6'd0;
                    // Minutes rolled over, increment hours
                    if (Hours == HOURS_MAX)
                        next_hours = 5'd0;
                    else
                        next_hours = Hours + 5'd1;
                end else begin
                    next_mins = Mins + 6'd1;
                    next_hours = Hours; // No hour change
                end
            end else begin
                next_secs = Secs + 6'd1;
                next_mins = Mins;    // No minute change
                next_hours = Hours;  // No hour change
            end

            // Update registers only when value changes to reduce toggling/power
            if (Secs != next_secs)
                Secs <= next_secs;
            if (Mins != next_mins)
                Mins <= next_mins;
            if (Hours != next_hours)
                Hours <= next_hours;
        end
    end

endmodule