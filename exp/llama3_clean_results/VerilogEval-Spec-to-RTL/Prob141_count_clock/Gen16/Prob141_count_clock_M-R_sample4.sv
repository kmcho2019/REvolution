module TimeCounter(
    input clk,
    input reset,
    input ena,
    output reg [3:0] hours,
    output reg [5:0] minutes,
    output reg [5:0] seconds,
    output reg pm
);

    always_ff @(posedge clk) begin
        if (reset) begin
            hours <= 0; // 12 in 12-hour format
            minutes <= 0;
            seconds <= 0;
            pm <= 0; // AM
        end else if (ena) begin
            if (seconds == 59) begin
                seconds <= 0;
                if (minutes == 59) begin
                    minutes <= 0;
                    if (hours == 11) begin // 12 in binary
                        hours <= 1; // 1 in binary (after 12, it's 1)
                        pm <= ~pm; // Toggle AM/PM
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

endmodule

module TopModule(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    wire [3:0] hours;
    wire [5:0] minutes;
    wire [5:0] seconds;
    wire pm_flag;

    TimeCounter time_counter(clk, reset, ena, hours, minutes, seconds, pm_flag);

    assign pm = pm_flag;

    // Directly calculate tens and ones places for hours, minutes, and seconds
    assign hh = {4'b0000, hours[3:2], hours[1:0]}; // BCD for hours
    assign mm = {4'b0000, minutes[5:4], minutes[3:0]}; // BCD for minutes
    assign ss = {4'b0000, seconds[5:4], seconds[3:0]}; // BCD for seconds

endmodule