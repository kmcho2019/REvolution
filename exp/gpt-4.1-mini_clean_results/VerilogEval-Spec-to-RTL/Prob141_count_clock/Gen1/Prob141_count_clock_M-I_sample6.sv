module TopModule (
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

    // Increment a BCD digit with wraparound to 0 at limit
    function [3:0] bcd_increment;
        input [3:0] digit;
        input [3:0] limit; // max valid digit before wrapping
        begin
            if (digit == limit)
                bcd_increment = 4'd0;
            else
                bcd_increment = digit + 4'd1;
        end
    endfunction

    // Returns 1 if digit is at limit
    function is_bcd_max;
        input [3:0] digit;
        input [3:0] limit;
        begin
            is_bcd_max = (digit == limit);
        end
    endfunction

    // Increment seconds by 1 second (BCD), return 1 if rollover (59->00)
    function increment_seconds;
        input [7:0] curr_ss;
        output reg [7:0] new_ss;
        begin
            if (curr_ss == 8'h59) begin
                new_ss = 8'h00;
                increment_seconds = 1;
            end else begin
                // increment units digit
                if (is_bcd_max(curr_ss[3:0],4'd9)) begin
                    new_ss[3:0] = 4'd0;
                    new_ss[7:4] = bcd_increment(curr_ss[7:4], 4'd5);
                end else begin
                    new_ss[3:0] = curr_ss[3:0] + 4'd1;
                    new_ss[7:4] = curr_ss[7:4];
                end
                increment_seconds = 0;
            end
        end
    endfunction

    // Increment minutes by 1 minute (BCD), return 1 if rollover (59->00)
    function increment_minutes;
        input [7:0] curr_mm;
        output reg [7:0] new_mm;
        begin
            if (curr_mm == 8'h59) begin
                new_mm = 8'h00;
                increment_minutes = 1;
            end else begin
                if (is_bcd_max(curr_mm[3:0],4'd9)) begin
                    new_mm[3:0] = 4'd0;
                    new_mm[7:4] = bcd_increment(curr_mm[7:4], 4'd5);
                end else begin
                    new_mm[3:0] = curr_mm[3:0] + 4'd1;
                    new_mm[7:4] = curr_mm[7:4];
                end
                increment_minutes = 0;
            end
        end
    endfunction

    // Increment hour by 1 in 12-hour BCD format.
    // Hours range from 1 to 12.
    // Returns new hour value.
    function [7:0] increment_hour;
        input [7:0] curr_hh;
        begin
            // 12 -> 1
            if (curr_hh == 8'h12) begin
                increment_hour = 8'h01;
            end else begin
                // Extract digits
                reg [3:0] tens, units;
                tens = curr_hh[7:4];
                units = curr_hh[3:0];
                // If units digit is 9, next is (tens+1)0
                if (units == 4'd9) begin
                    tens = tens + 4'd1;
                    units = 4'd0;
                end else begin
                    units = units + 4'd1;
                end
                increment_hour = {tens, units};
            end
        end
    endfunction

    always @(posedge clk) begin
        if (reset) begin
            pm <= 0;           // AM
            hh <= 8'h12;       // 12
            mm <= 8'h00;
            ss <= 8'h00;
        end else if (ena) begin
            reg rollover_sec, rollover_min;
            reg [7:0] new_ss, new_mm, new_hh;

            // Increment seconds, check rollover
            rollover_sec = increment_seconds(ss, new_ss);

            if (rollover_sec) begin
                // Seconds rolled over from 59->00; increment minutes
                rollover_min = increment_minutes(mm, new_mm);

                if (rollover_min) begin
                    // Minutes rolled over from 59->00; increment hours
                    new_hh = increment_hour(hh);

                    // PM toggles on rollover from 11:59:59 to 12:00:00
                    // Detect transition from 11 to 12
                    if (hh == 8'h11) begin
                        pm <= ~pm;
                    end

                    hh <= new_hh;
                    mm <= new_mm;
                    ss <= new_ss;
                end else begin
                    // Minutes no rollover, update mm and ss only
                    mm <= new_mm;
                    ss <= new_ss;
                end
            end else begin
                // No second rollover; only update seconds
                ss <= new_ss;
            end
        end
    end

endmodule