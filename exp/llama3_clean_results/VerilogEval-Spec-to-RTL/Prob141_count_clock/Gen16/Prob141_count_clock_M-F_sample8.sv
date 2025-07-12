module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

reg [5:0] seconds;
reg [5:0] minutes;
reg [3:0] hours; // Internal representation 0-11 for hours
reg pm_flag;

always_ff @(posedge clk) begin
    if (reset) begin
        seconds <= 0;
        minutes <= 0;
        hours <= 0; // Reset hours to 0 (internally represents 12)
        pm_flag <= 0; // AM
    end else if (ena) begin
        if (seconds == 59) begin
            seconds <= 0;
            if (minutes == 59) begin
                minutes <= 0;
                if (hours == 11) begin
                    hours <= 0;
                    pm_flag <= ~pm_flag; // Toggle AM/PM
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

// BCD conversion for hours, considering 12-hour format
wire [3:0] hours_tens = (hours < 10)? 0 : 1;
wire [3:0] hours_ones = (hours == 0)? 2 : (hours > 9)? hours - 10 + 2 : hours;

// BCD conversion for minutes and seconds
wire [3:0] minutes_tens = (minutes >= 10)? minutes / 10 : 0;
wire [3:0] minutes_ones = (minutes >= 10)? minutes % 10 : minutes;
wire [3:0] seconds_tens = (seconds >= 10)? seconds / 10 : 0;
wire [3:0] seconds_ones = (seconds >= 10)? seconds % 10 : seconds;

// Assign outputs
assign pm = pm_flag;
assign hh = {4'b0000, hours_tens, hours_ones};
assign mm = {4'b0000, minutes_tens, minutes_ones};
assign ss = {4'b0000, seconds_tens, seconds_ones};

endmodule