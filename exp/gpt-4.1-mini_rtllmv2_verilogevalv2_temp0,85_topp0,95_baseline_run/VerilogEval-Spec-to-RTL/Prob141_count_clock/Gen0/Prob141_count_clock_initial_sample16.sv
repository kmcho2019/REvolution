module TopModule(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

    // Helper function to increment a BCD digit (4-bit) with max 9
    function [3:0] bcd_inc;
        input [3:0] digit;
        begin
            if(digit == 4'd9)
                bcd_inc = 4'd0;
            else
                bcd_inc = digit + 4'd1;
        end
    endfunction

    // Helper function to compare BCD two-digit number to decimal max
    function is_bcd_max;
        input [7:0] bcd_value;
        input integer max_decimal;
        reg [3:0] high_digit;
        reg [3:0] low_digit;
        reg [7:0] decimal_value;
        begin
            high_digit = bcd_value[7:4];
            low_digit = bcd_value[3:0];
            decimal_value = high_digit * 10 + low_digit;
            is_bcd_max = (decimal_value == max_decimal);
        end
    endfunction

    // Increment BCD two-digit number, max value given, wraps to zero
    function [7:0] bcd_two_digit_inc;
        input [7:0] value;
        input integer max_decimal;
        reg [3:0] high_digit;
        reg [3:0] low_digit;
        integer decimal_value;
        integer new_decimal;
        reg [3:0] new_high;
        reg [3:0] new_low;
        begin
            high_digit = value[7:4];
            low_digit = value[3:0];
            decimal_value = high_digit * 10 + low_digit;
            if(decimal_value == max_decimal)
                new_decimal = 0;
            else
                new_decimal = decimal_value + 1;
            new_high = new_decimal / 10;
            new_low = new_decimal % 10;
            bcd_two_digit_inc = {new_high[3:0], new_low[3:0]};
        end
    endfunction

    // Hours increment for 12-hour BCD clock (01-12)
    function [7:0] bcd_hour_inc;
        input [7:0] hour_bcd;
        reg [3:0] high_digit;
        reg [3:0] low_digit;
        integer decimal_hour;
        integer new_decimal;
        reg [3:0] new_high;
        reg [3:0] new_low;
        begin
            high_digit = hour_bcd[7:4];
            low_digit = hour_bcd[3:0];
            decimal_hour = high_digit * 10 + low_digit;
            if(decimal_hour == 12)
                new_decimal = 1;
            else
                new_decimal = decimal_hour + 1;
            new_high = new_decimal / 10;
            new_low = new_decimal % 10;
            bcd_hour_inc = {new_high[3:0], new_low[3:0]};
        end
    endfunction

    // Helper function to check if hour is 11 (for pm toggle at wrap)
    function is_hour_eleven;
        input [7:0] hour_bcd;
        reg [3:0] high_digit;
        reg [3:0] low_digit;
        integer decimal_hour;
        begin
            high_digit = hour_bcd[7:4];
            low_digit = hour_bcd[3:0];
            decimal_hour = high_digit * 10 + low_digit;
            is_hour_eleven = (decimal_hour == 11);
        end
    endfunction

    always @(posedge clk) begin
        if(reset) begin
            // Reset to 12:00:00 AM
            hh <= 8'h12; // 0x12 = 0001 0010 (BCD for 12)
            mm <= 8'h00;
            ss <= 8'h00;
            pm <= 1'b0;
        end
        else if(ena) begin
            // Increment seconds
            if(is_bcd_max(ss,59)) begin
                // Seconds wrap to 0, increment minutes
                ss <= 8'h00;
                if(is_bcd_max(mm,59)) begin
                    // Minutes wrap to 0, increment hour
                    mm <= 8'h00;
                    // Check hour wrap from 12 to 1
                    if(hh == 8'h12) begin
                        // Wrap hour from 12 to 1
                        hh <= 8'h01;
                        // Toggle pm on wrap from 12 to 1
                        pm <= ~pm;
                    end else begin
                        // Increment hour normally
                        hh <= bcd_hour_inc(hh);
                    end
                end else begin
                    // Increment minutes normally
                    mm <= bcd_two_digit_inc(mm,59);
                end
            end else begin
                // Increment seconds normally
                ss <= bcd_two_digit_inc(ss,59);
            end
        end
    end

endmodule