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

// Calculate BCD for hours, minutes, and seconds
wire [3:0] hours_tens = hours > 9 ? 1 : 0;
wire [3:0] hours_ones = hours > 9 ? hours - 10 : hours;
wire [3:0] minutes_tens = minutes[5:4] * 6 + minutes[3:2];
wire [3:0] minutes_ones = minutes[1:0];
wire [3:0] seconds_tens = seconds[5:4] * 6 + seconds[3:2];
wire [3:0] seconds_ones = seconds[1:0];

// Assign hh, mm, ss considering BCD format
assign pm = pm_flag;
assign hh = {4'b0000, hours_tens, hours_ones};
assign mm = {4'b0000, minutes_tens, minutes_ones};
assign ss = {4'b0000, seconds_tens, seconds_ones};

endmodule