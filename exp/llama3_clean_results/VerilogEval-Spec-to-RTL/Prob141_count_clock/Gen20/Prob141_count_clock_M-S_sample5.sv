module TopModule(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    reg [3:0] hours; // 0-11 for 12-hour clock
    reg [5:0] minutes; // 0-59
    reg [5:0] seconds; // 0-59

    always_ff @(posedge clk) begin
        if (reset) begin
            hours <= 0;
            minutes <= 0;
            seconds <= 0;
        end else if (ena) begin
            if (seconds == 59) begin
                seconds <= 0;
                if (minutes == 59) begin
                    minutes <= 0;
                    if (hours == 11) begin
                        hours <= 0;
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

    always_comb begin
        // BCD conversion for hours, minutes, and seconds
        if (hours == 0) begin
            hh = 8'b0001_0010; // 12
        end else if (hours <= 9) begin
            hh = {4'b0000, hours};
        end else begin
            hh = {4'b0001, hours};
        end

        mm = {4'b0000, minutes[5:4], minutes[3:0]};
        ss = {4'b0000, seconds[5:4], seconds[3:0]};
        pm = (hours >= 6); // 6-11: PM, 0-5: AM
    end

endmodule