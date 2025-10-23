module TopModule (
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

    // Increment a BCD digit (4 bits) with max limit before rollover to 0
    function [3:0] bcd_increment_digit;
        input [3:0] digit;
        input [3:0] limit; // max valid digit before rolling over to 0
        begin
            if (digit == limit)
                bcd_increment_digit = 4'd0;
            else
                bcd_increment_digit = digit + 4'd1;
        end
    endfunction

    // Increment BCD seconds or minutes by 1
    // Return incremented BCD value
    function [7:0] bcd_inc_0to59;
        input [7:0] curr_bcd;
        reg [3:0] tens, ones;
        begin
            tens = curr_bcd[7:4];
            ones = curr_bcd[3:0];
            if (ones == 4'd9) begin
                ones = 4'd0;
                tens = bcd_increment_digit(tens, 4'd5);
            end else begin
                ones = ones + 4'd1;
            end
            bcd_inc_0to59 = {tens, ones};
        end
    endfunction

    // Check if BCD seconds or minutes is at max (59)
    function is_59;
        input [7:0] curr_bcd;
        begin
            is_59 = (curr_bcd == 8'h59);
        end
    endfunction

    // Increment hour in 12-hour BCD format (1-12)
    // Returns next hour in BCD format
    function [7:0] increment_hour;
        input [7:0] curr_hh;
        reg [3:0] tens, ones;
        reg [7:0] next_hh;
        begin
            tens = curr_hh[7:4];
            ones = curr_hh[3:0];

            // Special cases:
            // If current hour == 12 -> next hour = 1
            if (curr_hh == 8'h12) begin
                next_hh = 8'h01;
            end else begin
                // Increment BCD hour by 1 carefully:
                if (ones == 4'd9) begin
                    ones = 4'd0;
                    tens = tens + 4'd1;
                end else begin
                    ones = ones + 4'd1;
                end

                next_hh = {tens, ones};

                // Clamp hour to max 12 (BCD 0x12)
                if (next_hh == 8'h13) begin
                    next_hh = 8'h01; // rollover to 1
                end
            end

            increment_hour = next_hh;
        end
    endfunction

    always @(posedge clk) begin
        if (reset) begin
            pm <= 1'b0;        // AM
            hh <= 8'h12;       // 12
            mm <= 8'h00;
            ss <= 8'h00;
        end else if (ena) begin
            reg [7:0] new_ss, new_mm, new_hh;
            reg rollover_sec, rollover_min, rollover_hour;
            
            // Increment seconds
            new_ss = bcd_inc_0to59(ss);
            rollover_sec = (ss == 8'h59);

            if (rollover_sec) begin
                // seconds rolled over, increment minutes
                new_mm = bcd_inc_0to59(mm);
                rollover_min = (mm == 8'h59);

                if (rollover_min) begin
                    // minutes rolled over, increment hours
                    new_hh = increment_hour(hh);
                    rollover_hour = (hh == 8'h11); // 11->12 triggers PM toggle

                    // toggle PM only when hour rolls from 11 to 12
                    if (rollover_hour)
                        pm <= ~pm;

                    hh <= new_hh;
                    mm <= new_mm;
                    ss <= 8'h00;  // seconds reset on rollover
                end else begin
                    // minutes no rollover, update minutes and reset seconds
                    mm <= new_mm;
                    ss <= 8'h00;
                end
            end else begin
                // no second rollover, update seconds only
                ss <= new_ss;
            end
        end
    end

endmodule