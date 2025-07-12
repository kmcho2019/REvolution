module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

reg [3:0] hours_tens;
reg [3:0] hours_units;
reg [3:0] minutes_tens;
reg [3:0] minutes_units;
reg [3:0] seconds_tens;
reg [3:0] seconds_units;
reg pm_flag;

always @(posedge clk) begin
    if (reset) begin
        // Reset the clock to 12:00 AM
        hours_tens <= 1;
        hours_units <= 2;
        minutes_tens <= 0;
        minutes_units <= 0;
        seconds_tens <= 0;
        seconds_units <= 0;
        pm_flag <= 1'b0; // AM
    end else if (ena) begin
        // Increment the seconds counter
        if (seconds_units == 9) begin
            seconds_units <= 0;
            if (seconds_tens == 5) begin
                seconds_tens <= 0;
                // Increment the minutes counter
                if (minutes_units == 9) begin
                    minutes_units <= 0;
                    if (minutes_tens == 5) begin
                        minutes_tens <= 0;
                        // Increment the hours counter
                        if (hours_units == 9 && hours_tens == 1) begin
                            // 12:59 -> 1:00
                            hours_tens <= 0;
                            hours_units <= 1;
                            pm_flag <= ~pm_flag; // Toggle AM/PM
                        end else if (hours_units == 2 && hours_tens == 1) begin
                            // 12:XX -> 1:00
                            hours_tens <= 0;
                            hours_units <= 1;
                        end else if (hours_units == 3 && hours_tens == 1) begin
                            // 12:59 -> 1:00 (handle 12:59 to 1:00 correctly)
                            hours_tens <= 0;
                            hours_units <= 1;
                            pm_flag <= ~pm_flag; // Toggle AM/PM
                        end else begin
                            // Increment hours
                            if (hours_units == 9) begin
                                hours_units <= 0;
                                hours_tens <= hours_tens + 1;
                            end else begin
                                hours_units <= hours_units + 1;
                            end
                        end
                    end else begin
                        minutes_tens <= minutes_tens + 1;
                    end
                end else begin
                    minutes_units <= minutes_units + 1;
                end
            end else begin
                seconds_tens <= seconds_tens + 1;
            end
        end else begin
            seconds_units <= seconds_units + 1;
        end
    end
end

assign pm = pm_flag;
assign hh = {hours_tens, hours_units, 4'b0000};
assign mm = {minutes_tens, minutes_units, 4'b0000};
assign ss = {seconds_tens, seconds_units, 4'b0000};

endmodule