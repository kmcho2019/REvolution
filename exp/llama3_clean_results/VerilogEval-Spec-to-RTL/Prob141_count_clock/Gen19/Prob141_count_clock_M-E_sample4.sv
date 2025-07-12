module TopModule(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    reg [3:0] hours_int; // Internal hours counter (0-11 for 12-hour clock)
    reg [5:0] minutes_int; // Internal minutes counter (0-59)
    reg [5:0] seconds_int; // Internal seconds counter (0-59)
    reg pm_int; // Internal AM/PM indicator

    always_ff @(posedge clk) begin
        if (reset) begin
            hours_int <= 0; // Start at 12:00 AM (hours = 0 for 12)
            minutes_int <= 0;
            seconds_int <= 0;
            pm_int <= 0; // AM
        end else if (ena) begin
            if (seconds_int == 59) begin
                seconds_int <= 0;
                if (minutes_int == 59) begin
                    minutes_int <= 0;
                    if (hours_int == 11) begin
                        hours_int <= 0;
                        pm_int <= ~pm_int; // Toggle AM/PM
                    end else begin
                        hours_int <= hours_int + 1;
                    end
                end else begin
                    minutes_int <= minutes_int + 1;
                end
            end else begin
                seconds_int <= seconds_int + 1;
            end
        end
    end

    // Convert internal time counters to BCD
    always_comb begin
        if (hours_int == 0) begin // 12 AM/PM
            hh = 8'b0001_0010;
        end else if (hours_int <= 9) begin
            hh = {4'b0000, hours_int};
        end else begin
            hh = {4'b0001, hours_int};
        end

        mm = {4'b0000, minutes_int[5:4], minutes_int[3:0]};
        ss = {4'b0000, seconds_int[5:4], seconds_int[3:0]};
        pm = pm_int;
    end

endmodule