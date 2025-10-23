module TopModule (
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

    // Separate BCD digits for hours, minutes, seconds
    reg [3:0] hh_tens, hh_units;
    reg [3:0] mm_tens, mm_units;
    reg [3:0] ss_tens, ss_units;

    // Helper task to increment a BCD digit (0-9)
    function [3:0] bcd_inc_digit;
        input [3:0] digit;
        begin
            if (digit == 4'd9)
                bcd_inc_digit = 4'd0;
            else
                bcd_inc_digit = digit + 4'd1;
        end
    endfunction

    // Determine if seconds = 59 (ss_tens == 5 and ss_units == 9)
    wire sec_max = (ss_tens == 4'd5) && (ss_units == 4'd9);
    // Determine if minutes = 59
    wire min_max = (mm_tens == 4'd5) && (mm_units == 4'd9);
    // Determine if hours = 11 (hh_tens=1, hh_units=1)
    wire hour_11 = (hh_tens == 4'd1) && (hh_units == 4'd1);
    // Determine if hours = 12 (hh_tens=1, hh_units=2)
    wire hour_12 = (hh_tens == 4'd1) && (hh_units == 4'd2);

    always @(posedge clk) begin
        if (reset) begin
            // Reset to 12:00:00 AM
            pm <= 1'b0; // AM
            hh_tens <= 4'd1;
            hh_units <= 4'd2;
            mm_tens <= 4'd0;
            mm_units <= 4'd0;
            ss_tens <= 4'd0;
            ss_units <= 4'd0;
        end else if (ena) begin
            // Increment seconds
            if (sec_max) begin
                ss_tens <= 4'd0;
                ss_units <= 4'd0;

                // Increment minutes
                if (min_max) begin
                    mm_tens <= 4'd0;
                    mm_units <= 4'd0;

                    // Increment hours (1 to 12)
                    if (hour_12) begin
                        // wrap from 12 to 1
                        hh_tens <= 4'd0;
                        hh_units <= 4'd1;
                    end else if (hour_11) begin
                        // from 11 to 12 toggle PM
                        hh_tens <= 4'd1;
                        hh_units <= 4'd2;
                        pm <= ~pm;
                    end else begin
                        // Increment hour digit-wise, considering valid hour BCD digits
                        // Increment units digit of hour
                        if (hh_units == 4'd9) begin
                            hh_units <= 4'd0;
                            hh_tens <= hh_tens + 4'd1;
                        end else begin
                            hh_units <= hh_units + 4'd1;
                        end
                    end

                end else begin
                    // Increment minutes digit-wise
                    if (mm_units == 4'd9) begin
                        mm_units <= 4'd0;
                        mm_tens <= mm_tens + 4'd1;
                    end else begin
                        mm_units <= mm_units + 4'd1;
                    end
                end

            end else begin
                // Increment seconds digit-wise
                if (ss_units == 4'd9) begin
                    ss_units <= 4'd0;
                    ss_tens <= ss_tens + 4'd1;
                end else begin
                    ss_units <= ss_units + 4'd1;
                end
            end
        end
    end

    // Combine digits to outputs
    always @(*) begin
        hh = {hh_tens, hh_units};
        mm = {mm_tens, mm_units};
        ss = {ss_tens, ss_units};
    end

endmodule