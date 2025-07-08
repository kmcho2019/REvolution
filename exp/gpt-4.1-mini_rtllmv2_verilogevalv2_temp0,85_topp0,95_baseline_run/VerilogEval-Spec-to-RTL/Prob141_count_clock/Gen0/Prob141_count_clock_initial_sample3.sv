module TopModule (
    input  clk,
    input  reset,
    input  ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

    // Helper function to increment a BCD digit (4 bits) with limit
    // Returns new digit and a carry if digit rolls over
    function automatic [4:0] bcd_increment(input [3:0] digit, input [3:0] limit);
        reg [4:0] res;
        begin
            if(digit == limit) begin
                res = {1'b1, 4'd0}; // carry = 1, digit reset to 0
            end else begin
                res = {1'b0, digit + 1};
            end
            bcd_increment = res;
        end
    endfunction

    // Increment a BCD two-digit number (8 bits) given max tens and units limits.
    // Returns new value and carry if rolled over.
    function automatic [9:0] bcd_two_digit_increment(
        input [7:0] val,
        input [3:0] tens_limit,
        input [3:0] units_limit
    );
        reg carry_units, carry_tens;
        reg [3:0] units_new, tens_new;
        reg [4:0] inc_units;
        reg [4:0] inc_tens;
        begin
            inc_units = bcd_increment(val[3:0], units_limit);
            units_new = inc_units[3:0];
            carry_units = inc_units[4];

            if(carry_units) begin
                inc_tens = bcd_increment(val[7:4], tens_limit);
                tens_new = inc_tens[3:0];
                carry_tens = inc_tens[4];
            end else begin
                tens_new = val[7:4];
                carry_tens = 0;
            end

            bcd_two_digit_increment = {carry_tens, tens_new, units_new};
        end
    endfunction

    // Hour increment function for 12-hour clock in BCD
    // Hours go from 01 to 12.
    // Returns new hour and carry if hour rolled over 12->1 (indicates toggle pm)
    function automatic [8:0] bcd_hour_increment(input [7:0] val);
        reg [3:0] tens, units;
        reg [7:0] next_val;
        reg carry;
        begin
            tens = val[7:4];
            units = val[3:0];

            // increment units digit
            if (units == 4'd9) begin
                units = 4'd0;
                // increment tens digit
                if (tens == 4'd1) begin
                    // Check if hour is 12
                    if (val == 8'h12) begin
                        // rollover to 01 and carry
                        next_val = 8'h01;
                        carry = 1'b1;
                    end else begin
                        // tens digit increment (should not happen other than 1 or 0)
                        tens = 4'd2; // invalid for hours, but just in case
                        carry = 0;
                        next_val = {tens, units};
                    end
                end else if (tens == 4'd0) begin
                    tens = 4'd1;
                    carry = 0;
                    next_val = {tens, units};
                end else begin
                    // invalid tens digit, just increment normally
                    carry = 0;
                    next_val = {tens, units};
                end
            end else begin
                units = units + 1;
                carry = 0;
                next_val = {tens, units};
                // special check: if next_val == 12, no carry yet, only roll over after increment past 12
                if (val == 8'h12) begin
                    next_val = 8'h01;
                    carry = 1;
                end
            end

            // But the above logic is complicated. Let's simplify by enumerating hour increments:

            // Let's rewrite function as:
            // Convert BCD hour to integer, increment modulo 12 (1..12), then convert back to BCD

            integer hour_int;
            reg [7:0] bcd_out;
            begin
                hour_int = (val[7:4]*10) + val[3:0];
                if (hour_int == 12)
                    hour_int = 1;
                else
                    hour_int = hour_int + 1;

                // Convert hour_int back to BCD
                bcd_out[7:4] = hour_int / 10;
                bcd_out[3:0] = hour_int % 10;

                // carry if hour rolls over from 12 to 1
                carry = (val == 8'h12) ? 1'b1 : 1'b0;

                bcd_hour_increment = {carry, bcd_out};
            end
        end
    endfunction

    always @(posedge clk) begin
        if (reset) begin
            // Reset to 12:00:00 AM
            hh <= 8'h12;
            mm <= 8'h00;
            ss <= 8'h00;
            pm <= 1'b0;
        end else if (ena) begin
            // Increment seconds
            // increment ss with limits: tens max 5, units max 9
            // bcd_two_digit_increment returns carry at bit 9
            reg [9:0] ss_inc;
            reg [9:0] mm_inc;
            reg [8:0] hh_inc;

            ss_inc = bcd_two_digit_increment(ss, 4'd5, 4'd9);
            ss <= ss_inc[7:0];

            if (ss_inc[9]) begin // seconds rolled over
                mm_inc = bcd_two_digit_increment(mm, 4'd5, 4'd9);
                mm <= mm_inc[7:0];

                if (mm_inc[9]) begin // minutes rolled over
                    hh_inc = bcd_hour_increment(hh);
                    hh <= hh_inc[7:0];
                    if (hh_inc[8]) begin
                        pm <= ~pm;
                    end
                end
            end
        end
    end

endmodule