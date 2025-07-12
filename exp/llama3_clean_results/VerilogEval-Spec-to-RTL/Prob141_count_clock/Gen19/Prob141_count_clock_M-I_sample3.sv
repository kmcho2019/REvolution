module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

// Separate counters for seconds, minutes, and hours
reg [5:0] seconds;
reg [5:0] minutes;
reg [3:0] hours;  // 4-bit counter to represent 1-12
reg pm_flag;      // Separate variable for AM/PM indicator

always_ff @(posedge clk) begin
    if (reset) begin
        // Reset to "12:00:00 AM"
        seconds <= 0;
        minutes <= 0;
        hours <= 0;  // 0 corresponds to 12 in a 12-hour clock
        pm_flag <= 1'b0;  // Reset to AM
    end else if (ena) begin
        // Increment seconds
        if (seconds == 59) begin
            seconds <= 0;
            // Increment minutes
            if (minutes == 59) begin
                minutes <= 0;
                // Increment hours
                if (hours == 11) begin
                    hours <= 0;
                    pm_flag <= ~pm_flag;  // Toggle AM/PM
                end else begin
                    hours <= hours + 1;
                end
            end else begin
                minutes <= minutes + 1;
            end
        end else begin
            seconds <= seconds + 1;
        end
    end
end

// Calculate BCD for hours
reg [3:0] hours_tens;
reg [3:0] hours_ones;

always_comb begin
    case (hours)
        0: begin
            hours_tens = 1;
            hours_ones = 2;
        end
        1: begin
            hours_tens = 0;
            hours_ones = 1;
        end
        2: begin
            hours_tens = 0;
            hours_ones = 2;
        end
        3: begin
            hours_tens = 0;
            hours_ones = 3;
        end
        4: begin
            hours_tens = 0;
            hours_ones = 4;
        end
        5: begin
            hours_tens = 0;
            hours_ones = 5;
        end
        6: begin
            hours_tens = 0;
            hours_ones = 6;
        end
        7: begin
            hours_tens = 0;
            hours_ones = 7;
        end
        8: begin
            hours_tens = 0;
            hours_ones = 8;
        end
        9: begin
            hours_tens = 0;
            hours_ones = 9;
        end
        10: begin
            hours_tens = 1;
            hours_ones = 0;
        end
        11: begin
            hours_tens = 1;
            hours_ones = 1;
        end
    endcase
end

// Calculate BCD for minutes and seconds
reg [3:0] minutes_tens;
reg [3:0] minutes_ones;
reg [3:0] seconds_tens;
reg [3:0] seconds_ones;

always_comb begin
    minutes_tens = minutes / 10;
    minutes_ones = minutes % 10;
    seconds_tens = seconds / 10;
    seconds_ones = seconds % 10;
end

// Assign hh, mm, ss considering BCD format
assign pm = pm_flag;
assign hh = {4'b0000, hours_tens, hours_ones};
assign mm = {4'b0000, minutes_tens, minutes_ones};
assign ss = {4'b0000, seconds_tens, seconds_ones};

endmodule