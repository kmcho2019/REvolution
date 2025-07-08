module TopModule (
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

    // Helper function to increment a BCD digit (4 bits) with a max value
    function [4:0] bcd_increment; // 5 bits to handle carry out
        input [3:0] digit;
        input [3:0] max_digit;
        begin
            if (digit == max_digit)
                bcd_increment = 5'd0; // reset to 0 and carry
            else
                bcd_increment = digit + 1;
        end
    endfunction

    // Internal signals for hours, minutes, seconds digits
    reg [3:0] ss_ones, ss_tens;
    reg [3:0] mm_ones, mm_tens;
    reg [3:0] hh_ones, hh_tens;

    always @(posedge clk) begin
        if (reset) begin
            // Reset to 12:00:00 AM
            hh_tens <= 4'd1;   // '1'
            hh_ones <= 4'd2;   // '2' => 12
            mm_tens <= 4'd0;
            mm_ones <= 4'd0;
            ss_tens <= 4'd0;
            ss_ones <= 4'd0;
            pm <= 1'b0;        // AM
        end else if (ena) begin
            // Increment seconds
            {ss_ones, ss_tens} = {ss_ones, ss_tens}; // To avoid latches
            {mm_ones, mm_tens} = {mm_ones, mm_tens};
            {hh_ones, hh_tens} = {hh_ones, hh_tens};

            // Increment seconds ones digit
            if (ss_ones == 4'd9) begin
                ss_ones <= 4'd0;
                // Increment seconds tens digit
                if (ss_tens == 4'd5) begin
                    ss_tens <= 4'd0;
                    // Increment minutes
                    if (mm_ones == 4'd9) begin
                        mm_ones <= 4'd0;
                        if (mm_tens == 4'd5) begin
                            mm_tens <= 4'd0;
                            // Increment hours
                            // Hours count 01 to 12 BCD
                            if (hh_tens == 4'd1) begin
                                if (hh_ones == 4'd2) begin
                                    // Transition from 12 -> 1
                                    hh_tens <= 4'd0;
                                    hh_ones <= 4'd1;
                                    pm <= ~pm; // toggle am/pm on hour rollover
                                end else begin
                                    // 11 -> 12 handled here: 11 (1,1) to 12 (1,2)
                                    hh_ones <= hh_ones + 1;
                                end
                            end else begin
                                // tens = 0 means hour 01 to 09
                                if (hh_ones == 4'd9) begin
                                    hh_tens <= 4'd1;
                                    hh_ones <= 4'd0;
                                end else if (hh_ones == 4'd1) begin
                                    // 10 handled as tens=1, ones=0
                                    // For 9->10 transition
                                    hh_tens <= 4'd1;
                                    hh_ones <= 4'd0;
                                end else begin
                                    // Normal increment from 01-09
                                    if (hh_ones == 4'd9) begin
                                        // Should not occur because hour max is 12
                                        hh_tens <= 4'd1;
                                        hh_ones <= 4'd0;
                                    end else begin
                                        hh_ones <= hh_ones + 1;
                                    end
                                end
                            end
                        end else begin
                            mm_tens <= mm_tens + 1;
                        end
                    end else begin
                        mm_ones <= mm_ones + 1;
                    end
                end else begin
                    ss_tens <= ss_tens + 1;
                end
            end else begin
                ss_ones <= ss_ones + 1;
            end
        end
    end

    // Output assignments: BCD digits concatenated for each time unit
    always @(*) begin
        hh = {hh_tens, hh_ones};
        mm = {mm_tens, mm_ones};
        ss = {ss_tens, ss_ones};
    end

endmodule