module TopModule(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

    // Internal signals for BCD digits
    reg [3:0] ss_ones;
    reg [3:0] ss_tens;
    reg [3:0] mm_ones;
    reg [3:0] mm_tens;
    reg [3:0] hh_ones;
    reg [3:0] hh_tens;

    // Convert BCD digits to 8-bit output
    always @* begin
        ss = {ss_tens, ss_ones};
        mm = {mm_tens, mm_ones};
        hh = {hh_tens, hh_ones};
    end

    // Function to increment BCD digits with max value check
    // Returns 1 if rollover occurred, 0 otherwise
    function increment_bcd(
        input [3:0] tens,
        input [3:0] ones,
        input integer max_tens,
        input integer max_ones,
        output reg [3:0] new_tens,
        output reg [3:0] new_ones
    );
        begin
            if (ones == max_ones) begin
                new_ones = 4'd0;
                if (tens == max_tens) begin
                    new_tens = 4'd0;
                    increment_bcd = 1;
                end else begin
                    new_tens = tens + 1;
                    increment_bcd = 0;
                end
            end else begin
                new_ones = ones + 1;
                new_tens = tens;
                increment_bcd = 0;
            end
        end
    endfunction

    always @(posedge clk) begin
        if (reset) begin
            // Reset to 12:00:00 AM
            pm <= 1'b0;
            hh_tens <= 4'd1;  // 12 is "1" "2" in BCD
            hh_ones <= 4'd2;
            mm_tens <= 4'd0;
            mm_ones <= 4'd0;
            ss_tens <= 4'd0;
            ss_ones <= 4'd0;
        end else if (ena) begin
            // Increment seconds
            reg sec_rollover;
            reg min_rollover;
            reg hr_rollover;
            sec_rollover = increment_bcd(ss_tens, ss_ones, 4'd5, 4'd9, ss_tens, ss_ones);
            if (sec_rollover) begin
                // Increment minutes
                min_rollover = increment_bcd(mm_tens, mm_ones, 4'd5, 4'd9, mm_tens, mm_ones);
                if (min_rollover) begin
                    // Increment hours (1 to 12)
                    // Handle BCD increment for 1-12:
                    // Hours valid range: 01 to 12 (BCD)
                    // Sequence: 01,02,...,09,10,11,12, then back to 01
                    if (hh_tens == 4'd0) begin
                        // hours 01 to 09
                        if (hh_ones == 4'd9) begin
                            hh_tens <= 4'd1;
                            hh_ones <= 4'd0;
                            // hour now 10
                            hr_rollover = 0;
                        end else begin
                            hh_ones <= hh_ones + 1;
                            hr_rollover = 0;
                        end
                    end else if (hh_tens == 4'd1) begin
                        // hours 10 to 12
                        if (hh_ones == 4'd2) begin
                            // rollover from 12 to 01
                            hh_tens <= 4'd0;
                            hh_ones <= 4'd1;
                            hr_rollover = 1;
                        end else begin
                            hh_ones <= hh_ones + 1;
                            hr_rollover = 0;
                        end
                    end else begin
                        // Should never occur, reset to 01 to be safe
                        hh_tens <= 4'd0;
                        hh_ones <= 4'd1;
                        hr_rollover = 1;
                    end

                    if (hr_rollover) begin
                        pm <= ~pm; // Toggle AM/PM on hour rollover from 12 to 1
                    end
                end
            end
        end
    end

endmodule