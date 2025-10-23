module TopModule(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

reg [3:0] seconds;
reg [3:0] minutes;
reg [3:0] hours;
reg pm_flag;

always @(posedge clk) begin
    if (reset) begin
        seconds <= 4'b0;
        minutes <= 4'b0;
        hours <= 4'b0001; // 12:00 AM
        pm_flag <= 1'b0; // AM
    end else if (ena) begin
        // Increment seconds counter
        if (seconds == 4'd59) begin
            seconds <= 4'b0;
            // Increment minutes counter
            if (minutes == 4'd59) begin
                minutes <= 4'b0;
                // Increment hours counter
                if (hours == 4'd12) begin
                    hours <= 4'b1; // 01
                    pm_flag <= ~pm_flag; // Toggle AM/PM
                end else begin
                    hours <= hours + 1'b1;
                end
            end else begin
                minutes <= minutes + 1'b1;
            end
        end else begin
            seconds <= seconds + 1'b1;
        end
    end
end

always @(posedge clk) begin
    // BCD encoding for hours, minutes, and seconds
    hh <= {hours[3], hours[2], hours[1], hours[0], 4'b0};
    mm <= {minutes[3], minutes[2], minutes[1], minutes[0], 4'b0};
    ss <= {seconds[3], seconds[2], seconds[1], seconds[0], 4'b0};
    pm <= pm_flag;
end

endmodule