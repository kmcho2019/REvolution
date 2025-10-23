module TopModule (
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

    // Initialize hours, minutes, and seconds to 0
    reg [7:0] hours;
    reg [7:0] minutes;
    reg [7:0] seconds;

    // Initialize the AM/PM indicator to AM (0)
    reg am_pm;

    always @(posedge clk) begin
        if (reset) begin
            // Reset the clock to "12:00 AM"
            hours <= 8'b0001_0010; // 12 in BCD
            minutes <= 8'b0000_0000; // 00 in BCD
            seconds <= 8'b0000_0000; // 00 in BCD
            am_pm <= 1'b0; // AM
        end else if (ena) begin
            // Increment the seconds
            if (seconds == 8'b0101_0111) begin // 59 in BCD
                seconds <= 8'b0000_0000; // 00 in BCD
                // Increment the minutes
                if (minutes == 8'b0101_0111) begin // 59 in BCD
                    minutes <= 8'b0000_0000; // 00 in BCD
                    // Increment the hours
                    if (hours == 8'b0001_0010 && am_pm) begin // 12 PM
                        hours <= 8'b0000_0001; // 1 in BCD
                        am_pm <= 1'b0; // AM
                    end else if (hours == 8'b0001_0010 && !am_pm) begin // 12 AM
                        hours <= 8'b0000_0001; // 1 in BCD
                        am_pm <= 1'b1; // PM
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

    // Assign the values to the output ports
    assign hh = hours;
    assign mm = minutes;
    assign ss = seconds;
    assign pm = am_pm;

endmodule