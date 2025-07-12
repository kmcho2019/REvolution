module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    reg [3:0] hours;
    reg [5:0] minutes;
    reg [5:0] seconds;
    reg [3:0] minutes_tens;
    reg [3:0] minutes_units;
    reg [3:0] seconds_tens;
    reg [3:0] seconds_units;

    always @(posedge clk) begin
        if (reset) begin
            hours <= 1; // Reset to 12:00:00 AM
            minutes <= 0;
            seconds <= 0;
            minutes_tens <= 0;
            minutes_units <= 0;
            seconds_tens <= 0;
            seconds_units <= 0;
        end else if (ena) begin
            if (seconds == 59) begin
                seconds <= 0;
                seconds_tens <= 0;
                seconds_units <= 0;
                if (minutes == 59) begin
                    minutes <= 0;
                    minutes_tens <= 0;
                    minutes_units <= 0;
                    if (hours == 12) begin
                        hours <= 1;
                    end else begin
                        hours <= hours + 1;
                    end
                end else begin
                    minutes <= minutes + 1;
                    if (minutes[3:0] < 10) begin
                        minutes_units <= minutes[3:0];
                        minutes_tens <= 0;
                    end else begin
                        minutes_units <= minutes[3:0] % 10;
                        minutes_tens <= minutes[3:0] / 10;
                    end
                end
            end else begin
                seconds <= seconds + 1;
                if (seconds[3:0] < 10) begin
                    seconds_units <= seconds[3:0];
                    seconds_tens <= 0;
                end else begin
                    seconds_units <= seconds[3:0] % 10;
                    seconds_tens <= seconds[3:0] / 10;
                end
            end
        end
    end

    // Derive the 'pm' output directly from the hours counter
    assign pm = (hours >= 7 && hours <= 12);

    // Assign outputs with correct BCD conversion
    assign hh = {4'b0000, hours};
    assign mm = {4'b0000, minutes_tens, 4'b0000, minutes_units};
    assign ss = {4'b0000, seconds_tens, 4'b0000, seconds_units};

endmodule