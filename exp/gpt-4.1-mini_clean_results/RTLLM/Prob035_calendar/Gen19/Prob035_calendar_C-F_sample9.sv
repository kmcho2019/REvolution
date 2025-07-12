module calendar (
    input  wire       CLK,
    input  wire       RST,
    output reg  [4:0] Hours,  // 0-23 requires 5 bits
    output reg  [5:0] Mins,   // 0-59 requires 6 bits
    output reg  [5:0] Secs    // 0-59 requires 6 bits
);

    // Parameterize max counts for clarity and easy modification
    localparam HOURS_MAX = 5'd23;
    localparam MINS_MAX  = 6'd59;
    localparam SECS_MAX  = 6'd59;

    // Internal next-state variables
    reg [5:0] next_secs;
    reg [5:0] next_mins;
    reg [4:0] next_hours;

    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            // Asynchronous reset all counters to zero
            Secs  <= 6'd0;
            Mins  <= 6'd0;
            Hours <= 5'd0;
        end else begin
            // Compute next seconds value and check for rollover
            if (Secs == SECS_MAX) begin
                next_secs = 6'd0;

                // Seconds rolled over, increment minutes
                if (Mins == MINS_MAX) begin
                    next_mins = 6'd0;

                    // Minutes rolled over, increment hours
                    if (Hours == HOURS_MAX)
                        next_hours = 5'd0;  // Roll over hours
                    else
                        next_hours = Hours + 5'd1;
                end else begin
                    next_mins = Mins + 6'd1;
                    next_hours = Hours; // Hours unchanged
                end
            end else begin
                next_secs  = Secs + 6'd1;
                next_mins  = Mins;   // Minutes unchanged
                next_hours = Hours;  // Hours unchanged
            end

            // Update registers only if value changes to reduce toggling
            if (Secs != next_secs)
                Secs <= next_secs;
            if (Mins != next_mins)
                Mins <= next_mins;
            if (Hours != next_hours)
                Hours <= next_hours;
        end
    end

endmodule