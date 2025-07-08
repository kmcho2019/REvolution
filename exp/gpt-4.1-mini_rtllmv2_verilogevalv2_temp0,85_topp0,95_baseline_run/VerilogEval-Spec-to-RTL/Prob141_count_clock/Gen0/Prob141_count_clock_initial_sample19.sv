module TopModule(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

    // Helper function to increment BCD digits (0-9) with carry output
    function [4:0] bcd_increment;
        input [3:0] digit;
        begin
            if (digit == 4'd9)
                bcd_increment = {1'b1, 4'd0}; // carry=1, digit=0
            else
                bcd_increment = {1'b0, digit + 1'b1};
        end
    endfunction

    // BCD digits for hours, minutes, seconds (each 2 digits)
    reg [3:0] hh_tens, hh_units;
    reg [3:0] mm_tens, mm_units;
    reg [3:0] ss_tens, ss_units;

    // Increment seconds BCD counter by 1
    task increment_seconds;
        reg carry;
        reg [4:0] result;
        begin
            // increment units
            result = bcd_increment(ss_units);
            ss_units = result[3:0];
            carry = result[4];
            if (carry) begin
                // increment tens
                result = bcd_increment(ss_tens);
                ss_tens = result[3:0];
                carry = result[4];
                if (carry) begin
                    // seconds overflow from 59 to 00
                    ss_tens = 4'd0;
                    ss_units = 4'd0;
                end
            end
        end
    endtask

    // Increment minutes BCD counter by 1
    task increment_minutes;
        reg carry;
        reg [4:0] result;
        begin
            // increment units
            result = bcd_increment(mm_units);
            mm_units = result[3:0];
            carry = result[4];
            if (carry) begin
                // increment tens
                result = bcd_increment(mm_tens);
                mm_tens = result[3:0];
                carry = result[4];
                if (carry) begin
                    // minutes overflow from 59 to 00
                    mm_tens = 4'd0;
                    mm_units = 4'd0;
                end
            end
        end
    endtask

    // Increment hours BCD counter by 1 (12-hour format)
    // hours range: 01 to 12 (BCD)
    // toggles pm when crossing 11->12
    task increment_hours;
        reg carry;
        reg [4:0] result_units, result_tens;
        reg [7:0] current_hh;
        reg is_11;
        begin
            // Compose current hour for convenience
            current_hh = {hh_tens, hh_units};

            // Check if current hour is 11 (BCD)
            is_11 = (hh_tens == 4'd1 && hh_units == 4'd1);

            // increment units digit
            result_units = bcd_increment(hh_units);
            hh_units = result_units[3:0];
            carry = result_units[4];
            if (carry) begin
                // increment tens digit
                result_tens = bcd_increment(hh_tens);
                hh_tens = result_tens[3:0];
                carry = result_tens[4];
                if (carry) begin
                    // theoretically tens digit never goes beyond 1 in hours
                    // but if it does, wrap around to 0 (handled below)
                end
            end

            // After increment, check if hour is 13 (BCD 0x13) => reset to 01
            // 13 decimal = tens=1, units=3
            if (hh_tens == 4'd1 && hh_units == 4'd3) begin
                hh_tens = 4'd0;
                hh_units = 4'd1;
            end

            // If we incremented from 11 to 12, toggle pm
            if (is_11 && hh_tens == 4'd1 && hh_units == 4'd2) begin
                pm <= ~pm;
            end
        end
    endtask

    always @(posedge clk) begin
        if (reset) begin
            // reset time to 12:00:00 AM
            hh_tens <= 4'd1;
            hh_units <= 4'd2;
            mm_tens <= 4'd0;
            mm_units <= 4'd0;
            ss_tens <= 4'd0;
            ss_units <= 4'd0;
            pm <= 1'b0; // AM
        end else if (ena) begin
            // increment seconds
            // check if seconds at 59 before increment
            if (ss_tens == 4'd5 && ss_units == 4'd9) begin
                // seconds wrap to 00 and increment minutes
                ss_tens <= 4'd0;
                ss_units <= 4'd0;

                if (mm_tens == 4'd5 && mm_units == 4'd9) begin
                    // minutes wrap to 00 and increment hours
                    mm_tens <= 4'd0;
                    mm_units <= 4'd0;
                    increment_hours();
                end else begin
                    // increment minutes normally
                    reg [4:0] result;
                    result = bcd_increment(mm_units);
                    mm_units <= result[3:0];
                    if (result[4]) begin
                        mm_tens <= mm_tens + 1'b1;
                    end
                end
            end else begin
                // increment seconds normally
                reg [4:0] result;
                result = bcd_increment(ss_units);
                ss_units <= result[3:0];
                if (result[4]) begin
                    ss_tens <= ss_tens + 1'b1;
                end
            end
        end
    end

    // Output concatenation of tens and units for hh, mm, ss
    always @(*) begin
        hh = {hh_tens, hh_units};
        mm = {mm_tens, mm_units};
        ss = {ss_tens, ss_units};
    end

endmodule