module TopModule (
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

    // Helper function to increment a BCD digit (4 bits) with max 9
    function [3:0] bcd_inc;
        input [3:0] digit;
        begin
            if (digit == 4'd9)
                bcd_inc = 4'd0;
            else
                bcd_inc = digit + 4'd1;
        end
    endfunction

    // Helper function to check if BCD digit is 9
    function bcd_is9;
        input [3:0] digit;
        begin
            bcd_is9 = (digit == 4'd9);
        end
    endfunction

    // Helper function to check if BCD digit is 5
    function bcd_is5;
        input [3:0] digit;
        begin
            bcd_is5 = (digit == 4'd5);
        end
    endfunction

    // Extract digits for hours, minutes and seconds
    wire [3:0] hh_tens = hh[7:4];
    wire [3:0] hh_ones = hh[3:0];
    wire [3:0] mm_tens = mm[7:4];
    wire [3:0] mm_ones = mm[3:0];
    wire [3:0] ss_tens = ss[7:4];
    wire [3:0] ss_ones = ss[3:0];

    // Next state registers
    reg [7:0] ss_next;
    reg [7:0] mm_next;
    reg [7:0] hh_next;
    reg pm_next;

    always @(*) begin
        // Default next state is current state
        ss_next = ss;
        mm_next = mm;
        hh_next = hh;
        pm_next = pm;

        if (ena) begin
            // Increment seconds
            if (ss_ones == 4'd9) begin
                if (ss_tens == 4'd5) begin
                    // seconds roll over to 00
                    ss_next = 8'b00000000;

                    // increment minutes
                    if (mm_ones == 4'd9) begin
                        if (mm_tens == 4'd5) begin
                            // minutes roll over to 00
                            mm_next = 8'b00000000;

                            // increment hours
                            // Hours count from 1 to 12 in BCD
                            // Possible hour BCD values: 01-09,10-12

                            // Check if hour is 11 (0x11) to toggle pm on next hour
                            if (hh == 8'h11) begin
                                // next hour is 12 (0x12)
                                hh_next = 8'h12;
                                pm_next = ~pm;
                            end else if (hh == 8'h12) begin
                                // next hour after 12 is 01
                                hh_next = 8'h01;
                            end else begin
                                // Normal increment hours in BCD
                                // Increment ones digit, with special case for 9->0 and tens increment
                                if (hh_ones == 4'd9) begin
                                    // ones digit wrap to 0, tens digit increment
                                    if (hh_tens == 4'd0) begin
                                        // from 09 to 10
                                        hh_next = 8'h10;
                                    end else if (hh_tens == 4'd1) begin
                                        // from 19 is invalid for 12-hour clock, so wrap handled above
                                        // but defensive: reset to 01
                                        hh_next = 8'h01;
                                    end else begin
                                        // defensive: just increment tens digit
                                        hh_next = {hh_tens + 4'd1, 4'd0};
                                    end
                                end else begin
                                    // increment ones digit normally
                                    hh_next = {hh_tens, hh_ones + 4'd1};
                                end
                            end
                        end else begin
                            // increment minutes tens digit
                            mm_next = {mm_tens + 4'd1, 4'd0};
                        end
                    end else begin
                        // increment minutes ones digit
                        mm_next = {mm_tens, mm_ones + 4'd1};
                    end

                end else begin
                    // increment seconds tens digit
                    ss_next = {ss_tens + 4'd1, 4'd0};
                end
            end else begin
                // increment seconds ones digit normally
                ss_next = {ss_tens, ss_ones + 4'd1};
            end
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            // synchronous reset
            pm <= 1'b0;    // AM
            hh <= 8'h12;   // 12
            mm <= 8'h00;   // 00
            ss <= 8'h00;   // 00
        end else begin
            pm <= pm_next;
            hh <= hh_next;
            mm <= mm_next;
            ss <= ss_next;
        end
    end

endmodule