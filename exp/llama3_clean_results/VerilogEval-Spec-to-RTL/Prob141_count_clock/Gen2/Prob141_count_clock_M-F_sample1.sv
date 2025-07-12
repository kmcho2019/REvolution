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
reg [3:0] hours;
reg pm_flag;

always @(posedge clk) begin
    if (reset) begin
        seconds <= 6'b000000; // Reset seconds to 0
        minutes <= 6'b000000; // Reset minutes to 0
        hours <= 4'b0001;     // Reset hours to 1 (12-hour format starts at 1 for AM)
        pm_flag <= 1'b0;      // Reset to AM
    end else if (ena) begin
        if (seconds == 6'b111011) begin // 59 in binary
            seconds <= 6'b000000;
            if (minutes == 6'b111011) begin // 59 in binary
                minutes <= 6'b000000;
                if (hours == 4'b1100) begin // 12 in binary
                    hours <= 4'b0001; // Wrap around to 1
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

// BCD encoding for hours, minutes, and seconds
reg [3:0] hours_tens, hours_units;
reg [3:0] minutes_tens, minutes_units;
reg [3:0] seconds_tens, seconds_units;

always @(*) begin
    hours_tens = hours / 10;
    hours_units = hours % 10;
    minutes_tens = minutes / 10;
    minutes_units = minutes % 10;
    seconds_tens = seconds / 10;
    seconds_units = seconds % 10;
end

assign hh = {4'b0000, hours_tens, 4'b0000, hours_units};
assign mm = {4'b0000, minutes_tens, 4'b0000, minutes_units};
assign ss = {4'b0000, seconds_tens, 4'b0000, seconds_units};

assign pm = pm_flag;

endmodule