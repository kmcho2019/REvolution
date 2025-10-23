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
        hours <= 4'b1001; // Reset hours to 12 in BCD
        minutes <= 6'b000000; // Reset minutes to 0 in BCD
        seconds <= 6'b000000; // Reset seconds to 0 in BCD
        am_pm <= 1'b0; // Reset to AM
    end else if (ena) begin
        if (seconds == 6'b010011) begin // 59 in BCD
            seconds <= 6'b000000; // Reset seconds
            if (minutes == 6'b010011) begin // 59 in BCD
                minutes <= 6'b000000; // Reset minutes
                if (hours == 4'b1001) begin // 12 in BCD
                    hours <= 4'b0001; // Wrap to 1
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
assign hh = {4'b0000, hours}; // Correct BCD representation for hours
assign mm = {minutes, 2'b00}; // Correct BCD representation for minutes
assign ss = {seconds, 2'b00}; // Correct BCD representation for seconds

endmodule