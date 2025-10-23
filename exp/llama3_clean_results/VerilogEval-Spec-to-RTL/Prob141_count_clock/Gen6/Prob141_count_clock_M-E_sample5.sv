module TopModule(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

parameter HOURS_WIDTH = 4;
parameter MINUTES_WIDTH = 6;
parameter SECONDS_WIDTH = 6;

reg [HOURS_WIDTH-1:0] hours;
reg [MINUTES_WIDTH-1:0] minutes;
reg [SECONDS_WIDTH-1:0] seconds;
reg am_pm;

always @(posedge clk) begin
    if (reset) begin
        hours <= 4'b0001; // Reset hours to 01 (1 in BCD)
        minutes <= 6'b000000; // Reset minutes to 00 (0 in BCD)
        seconds <= 6'b000000; // Reset seconds to 00 (0 in BCD)
        am_pm <= 1'b0; // Reset to AM
    end else if (ena) begin
        // Increment seconds
        if (seconds == 6'b010011) begin // 59 in BCD
            seconds <= 6'b000000; // Reset seconds to 00 (0 in BCD)
            // Increment minutes
            if (minutes == 6'b010011) begin // 59 in BCD
                minutes <= 6'b000000; // Reset minutes to 00 (0 in BCD)
                // Increment hours
                if (hours == 4'b1000) begin // 12 in BCD
                    hours <= 4'b0001; // Wrap hours to 01 (1 in BCD)
                    am_pm <= ~am_pm; // Toggle AM/PM
                end else begin
                    hours <= hours + 1; // Increment hours
                end
            end else begin
                minutes <= minutes + 1; // Increment minutes
            end
        end else begin
            seconds <= seconds + 1; // Increment seconds
        end
    end
end

assign pm = am_pm;
assign hh = {hours[3], hours[2], hours[1], hours[0], 4'b0000};
assign mm = {minutes[5], minutes[4], minutes[3], minutes[2], minutes[1], minutes[0], 2'b00};
assign ss = {seconds[5], seconds[4], seconds[3], seconds[2], seconds[1], seconds[0], 2'b00};

endmodule