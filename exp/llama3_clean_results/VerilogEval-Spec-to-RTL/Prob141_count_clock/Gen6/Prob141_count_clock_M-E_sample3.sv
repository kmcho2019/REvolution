module TopModule(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

reg [3:0] hours; // hours counter
reg [5:0] minutes; // minutes counter
reg [5:0] seconds; // seconds counter
reg am_pm; // AM/PM indicator

always @(posedge clk) begin
    if (reset) begin
        // Reset counters and AM/PM indicator
        hours <= 4'b0001; // 1 in BCD
        minutes <= 6'b000000; // 0 in BCD
        seconds <= 6'b000000; // 0 in BCD
        am_pm <= 1'b0; // AM
    end else if (ena) begin
        // Increment seconds counter
        if (seconds == 6'b010011) begin // 59 in BCD
            seconds <= 6'b000000; // Reset seconds counter
            // Increment minutes counter
            if (minutes == 6'b010011) begin // 59 in BCD
                minutes <= 6'b000000; // Reset minutes counter
                // Increment hours counter
                if (hours == 4'b1000) begin // 12 in BCD
                    hours <= 4'b0001; // Wrap hours counter to 1
                    am_pm <= ~am_pm; // Toggle AM/PM
                end else begin
                    hours <= hours + 1; // Increment hours counter
                end
            end else begin
                minutes <= minutes + 1; // Increment minutes counter
            end
        end else begin
            seconds <= seconds + 1; // Increment seconds counter
        end
    end
end

assign pm = am_pm;
assign hh = {hours[3], hours[2], hours[1], hours[0], 4'b0000};
assign mm = {minutes[5], minutes[4], minutes[3], minutes[2], minutes[1], minutes[0], 2'b00};
assign ss = {seconds[5], seconds[4], seconds[3], seconds[2], seconds[1], seconds[0], 2'b00};

endmodule