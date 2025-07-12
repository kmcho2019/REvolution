module calendar (
    input  wire       CLK,
    input  wire       RST,
    output reg  [4:0] Hours, // 0-23 range, needs 5 bits
    output reg  [5:0] Mins,  // 0-59 range
    output reg  [5:0] Secs   // 0-59 range
);

    // Combinational variables for next state calculation
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
            // Calculate next seconds
            if (Secs == 6'd59) begin
                next_secs = 6'd0;

                // Calculate next minutes
                if (Mins == 6'd59) begin
                    next_mins = 6'd0;

                    // Calculate next hours
                    if (Hours == 5'd23) begin
                        next_hours = 5'd0;
                    end else begin
                        next_hours = Hours + 5'd1;
                    end

                end else begin
                    next_mins = Mins + 6'd1;
                    next_hours = Hours; // No hour change
                end

            end else begin
                next_secs = Secs + 6'd1;
                next_mins = Mins;   // No minute change
                next_hours = Hours; // No hour change
            end

            // Update registers only if values changed to reduce toggle
            if (Secs != next_secs)
                Secs <= next_secs;
            if (Mins != next_mins)
                Mins <= next_mins;
            if (Hours != next_hours)
                Hours <= next_hours;
        end
    end

endmodule