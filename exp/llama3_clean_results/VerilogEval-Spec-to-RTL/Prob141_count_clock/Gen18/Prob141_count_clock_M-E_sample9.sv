module HourCounter(
    input clk,
    input reset,
    input ena,
    output reg [7:0] hh, // BCD for hours
    output reg pm
);

    reg [3:0] hours_int; // Internal hours counter (0-11 for 12-hour clock)

    always_ff @(posedge clk) begin
        if (reset) begin
            hours_int <= 0; // Start at 12:00 AM (hours = 0 for 12)
            pm <= 0; // AM
        end else if (ena) begin
            if (hours_int == 11) begin // Wrap around to 0 (12 AM/PM)
                hours_int <= 0;
                pm <= ~pm; // Toggle AM/PM
            end else begin
                hours_int <= hours_int + 1;
            end
        end
    end

    // Convert internal hours counter to BCD
    always_comb begin
        if (hours_int == 0) begin // 12 AM/PM
            hh = 8'b0001_0010;
        end else if (hours_int <= 9) begin
            hh = {4'b0000, hours_int};
        end else begin
            hh = {4'b0001, hours_int - 10};
        end
    end

endmodule

module MinuteCounter(
    input clk,
    input reset,
    input ena,
    output reg [7:0] mm // BCD for minutes
);

    reg [5:0] minutes_int; // Internal minutes counter (0-59)

    always_ff @(posedge clk) begin
        if (reset) begin
            minutes_int <= 0;
        end else if (ena) begin
            if (minutes_int == 59) begin
                minutes_int <= 0;
            end else begin
                minutes_int <= minutes_int + 1;
            end
        end
    end

    // Convert internal minutes counter to BCD
    always_comb begin
        mm = {4'b0000, minutes_int[5:4], minutes_int[3:0]};
    end

endmodule

module SecondCounter(
    input clk,
    input reset,
    input ena,
    output reg [7:0] ss // BCD for seconds
);

    reg [5:0] seconds_int; // Internal seconds counter (0-59)

    always_ff @(posedge clk) begin
        if (reset) begin
            seconds_int <= 0;
        end else if (ena) begin
            if (seconds_int == 59) begin
                seconds_int <= 0;
            end else begin
                seconds_int <= seconds_int + 1;
            end
        end
    end

    // Convert internal seconds counter to BCD
    always_comb begin
        ss = {4'b0000, seconds_int[5:4], seconds_int[3:0]};
    end

endmodule

module ClockController(
    input clk,
    input reset,
    input ena,
    output reg hour_ena,
    output reg minute_ena,
    output reg second_ena
);

    always_ff @(posedge clk) begin
        if (reset) begin
            hour_ena <= 0;
            minute_ena <= 0;
            second_ena <= 0;
        end else if (ena) begin
            second_ena <= 1;
            if (second_ena) begin
                minute_ena <= 0;
                hour_ena <= 0;
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

    reg hour_ena;
    reg minute_ena;
    reg second_ena;

    HourCounter hour_counter(clk, reset, hour_ena, hh, pm);
    MinuteCounter minute_counter(clk, reset, minute_ena, mm);
    SecondCounter second_counter(clk, reset, second_ena, ss);
    ClockController clock_controller(clk, reset, ena, hour_ena, minute_ena, second_ena);

endmodule