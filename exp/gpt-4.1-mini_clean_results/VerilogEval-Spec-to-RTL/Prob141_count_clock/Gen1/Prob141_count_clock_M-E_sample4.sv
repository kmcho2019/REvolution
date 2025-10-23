module TopModule (
    input        clk,
    input        reset,
    input        ena,
    output reg   pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

    // Separate BCD digits for seconds
    reg [3:0] ss_ones;
    reg [3:0] ss_tens;
    // Separate BCD digits for minutes
    reg [3:0] mm_ones;
    reg [3:0] mm_tens;
    // Separate BCD digits for hours (1-12)
    reg [3:0] hh_ones;
    reg [3:0] hh_tens;

    // Helper: increment digit with max limit, return carry
    function automatic [4:0] inc_bcd_digit;
        input [3:0] digit;
        input [3:0] max_val;
        reg [4:0] result;
        begin
            if (digit == max_val)
                result = {1'b1, 4'd0}; // carry=1, digit=0
            else
                result = {1'b0, digit + 4'd1}; // carry=0, digit incremented
            inc_bcd_digit = result;
        end
    endfunction

    always @(posedge clk) begin
        if (reset) begin
            // Reset to 12:00:00 AM
            ss_ones <= 4'd0;
            ss_tens <= 4'd0;
            mm_ones <= 4'd0;
            mm_tens <= 4'd0;
            hh_tens <= 4'd1; // 12 hours tens digit = 1
            hh_ones <= 4'd2; // 12 hours ones digit = 2
            pm <= 1'b0;      // AM
        end else if (ena) begin
            // Increment seconds ones
            reg carry_ss_ones;
            reg carry_ss_tens;
            reg carry_mm_ones;
            reg carry_mm_tens;
            reg carry_hh_ones;
            reg carry_hh_tens;

            {carry_ss_ones, ss_ones} = inc_bcd_digit(ss_ones, 4'd9);

            if (carry_ss_ones) begin
                {carry_ss_tens, ss_tens} = inc_bcd_digit(ss_tens, 4'd5);
            end else begin
                carry_ss_tens = 0;
            end

            // If seconds rolled over from 59 to 00, increment minutes
            if (carry_ss_tens) begin
                {carry_mm_ones, mm_ones} = inc_bcd_digit(mm_ones, 4'd9);

                if (carry_mm_ones) begin
                    {carry_mm_tens, mm_tens} = inc_bcd_digit(mm_tens, 4'd5);
                end else begin
                    carry_mm_tens = 0;
                end
            end else begin
                carry_mm_ones = 0;
                carry_mm_tens = 0;
            end

            // If minutes rolled over from 59 to 00, increment hours
            if (carry_mm_tens) begin
                // Implement hour increment with 12-hour logic (1-12)
                // Current hour as hh_tens and hh_ones
                // Hours count sequence in BCD:
                // 01,02,03,04,05,06,07,08,09,10,11,12, then back to 01 with pm toggle

                // To increment hours, consider current hh:
                // If hour == 12 (tens=1, ones=2), next is 1 (tens=0, ones=1) and toggle pm
                if ( (hh_tens == 4'd1) && (hh_ones == 4'd2) ) begin
                    // roll over from 12 to 1, toggle pm
                    hh_tens <= 4'd0;
                    hh_ones <= 4'd1;
                    pm <= ~pm;
                end else begin
                    // else increment hour normally
                    // hours from 01 to 09 -> tens=0, ones=1..9
                    // hours from 10 to 11 -> tens=1, ones=0 or 1

                    // Increment ones digit with max depends on tens
                    // if tens==0, ones max=9 except when tens=0 and ones=9 -> next is 10 (tens=1, ones=0)
                    if (hh_tens == 4'd0) begin
                        if (hh_ones == 4'd9) begin
                            // move to 10
                            hh_tens <= 4'd1;
                            hh_ones <= 4'd0;
                        end else begin
                            hh_ones <= hh_ones + 4'd1;
                            hh_tens <= 4'd0;
                        end
                    end else if (hh_tens == 4'd1) begin
                        // tens=1, ones range 0..2 (10,11,12)
                        if (hh_ones < 4'd2) begin
                            hh_ones <= hh_ones + 4'd1;
                            hh_tens <= 4'd1;
                        end else begin
                            // should not happen, as 12 handled above
                            // just reset to 1 for safety
                            hh_tens <= 4'd0;
                            hh_ones <= 4'd1;
                            pm <= ~pm;
                        end
                    end else begin
                        // invalid tens, reset hours to 1 for safety
                        hh_tens <= 4'd0;
                        hh_ones <= 4'd1;
                    end
                end
            end else begin
                // no minute rollover, so hours unchanged
                hh_tens <= hh_tens;
                hh_ones <= hh_ones;
                pm <= pm;
            end

            // Update seconds and minutes digits if no rollover was triggered
            if (~carry_ss_tens) begin
                ss_tens <= ss_tens;
            end

            if (~carry_mm_ones && carry_ss_tens) begin
                // minutes ones updated above
                mm_tens <= mm_tens;
            end

        end else begin
            // when ena=0, hold values
            ss_ones <= ss_ones;
            ss_tens <= ss_tens;
            mm_ones <= mm_ones;
            mm_tens <= mm_tens;
            hh_ones <= hh_ones;
            hh_tens <= hh_tens;
            pm <= pm;
        end
    end

    // Pack outputs as two BCD digits
    always @(*) begin
        hh = {hh_tens, hh_ones};
        mm = {mm_tens, mm_ones};
        ss = {ss_tens, ss_ones};
    end

endmodule