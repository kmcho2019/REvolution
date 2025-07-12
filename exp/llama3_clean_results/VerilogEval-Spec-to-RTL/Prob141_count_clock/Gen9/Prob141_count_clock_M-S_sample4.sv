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

initial begin
    hours_tens = 1; // 12 in BCD
    hours_units = 2;
    minutes_tens = 0;
    minutes_units = 0;
    seconds_tens = 0;
    seconds_units = 0;
    pm_flag = 1'b0;
end

always @(posedge clk) begin
    if (reset) begin
        hours_tens <= 1; // 12 in BCD
        hours_units <= 2;
        minutes_tens <= 0;
        minutes_units <= 0;
        seconds_tens <= 0;
        seconds_units <= 0;
        pm_flag <= 1'b0;
    end else if (ena) begin
        reg carry_seconds;
        reg carry_minutes;
        reg carry_hours;

        // Seconds counter
        if (seconds_units == 9 && seconds_tens == 5) begin
            seconds_tens <= 0;
            seconds_units <= 0;
            carry_seconds = 1'b1;
        end else if (seconds_units == 9) begin
            seconds_units <= 0;
            seconds_tens <= seconds_tens + 1;
            carry_seconds = 1'b0;
        end else begin
            seconds_units <= seconds_units + 1;
            carry_seconds = 1'b0;
        end

        // Minutes counter
        if (carry_seconds) begin
            if (minutes_units == 9 && minutes_tens == 5) begin
                minutes_tens <= 0;
                minutes_units <= 0;
                carry_minutes = 1'b1;
            end else if (minutes_units == 9) begin
                minutes_units <= 0;
                minutes_tens <= minutes_tens + 1;
                carry_minutes = 1'b0;
            end else begin
                minutes_units <= minutes_units + 1;
                carry_minutes = 1'b0;
            end
        end else begin
            carry_minutes = 1'b0;
        end

        // Hours counter
        if (carry_minutes) begin
            if (hours_units == 2 && hours_tens == 1) begin
                hours_tens <= 1;
                hours_units <= 0;
                pm_flag <= ~pm_flag;
            end else if (hours_units == 9 && hours_tens == 1) begin
                hours_tens <= 0;
                hours_units <= 0;
            end else if (hours_tens == 1 && hours_units == 2) begin
                hours_tens <= 0;
                hours_units <= 0;
                pm_flag <= 1'b1;
            end else begin
                if (hours_units == 9) begin
                    hours_units <= 0;
                    hours_tens <= hours_tens + 1;
                end else begin
                    hours_units <= hours_units + 1;
                end
            end
        end
    end
end

assign pm = pm_flag;
assign hh = {hours_tens, hours_units, 4'b0000};
assign mm = {minutes_tens, minutes_units, 4'b0000};
assign ss = {seconds_tens, seconds_units, 4'b0000};

endmodule