module TopModule (
    input        clk,
    input        reset,
    input        ena,
    output reg   pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

    // Helper functions to increment BCD digits
    // Increment a BCD byte representing two digits (0x00-0x59 or 0x01-0x12)
    // minutes and seconds go 00..59, hours go 01..12

    // Increment seconds or minutes BCD (range 00 to 59)
    function [7:0] inc_bcd_00_59;
        input [7:0] val;
        reg [3:0] ones, tens;
        begin
            ones = val[3:0];
            tens = val[7:4];
            if (ones == 4'd9) begin
                ones = 4'd0;
                if (tens == 4'd5)
                    tens = 4'd0;
                else
                    tens = tens + 1;
            end else begin
                ones = ones + 1;
            end
            inc_bcd_00_59 = {tens, ones};
        end
    endfunction

    // Increment hour BCD in 12-hour format from 01 to 12
    function [7:0] inc_bcd_01_12;
        input [7:0] val;
        reg [3:0] ones, tens;
        reg [7:0] next_val;
        begin
            ones = val[3:0];
            tens = val[7:4];

            // Convert to decimal for easier checking
            // decimal = tens * 10 + ones
            // Then increment and wrap between 1 and 12
            integer dec;
            dec = tens*10 + ones;
            dec = dec + 1;
            if (dec > 12)
                dec = 1;
            // convert back to BCD
            tens = dec / 10;
            ones = dec % 10;
            inc_bcd_01_12 = {tens, ones};
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
            // increment seconds
            if (ss == 8'h59) begin
                ss <= 8'h00;
                // increment minutes
                if (mm == 8'h59) begin
                    mm <= 8'h00;
                    // increment hour
                    if (hh == 8'h12) begin
                        hh <= 8'h01;
                        pm <= ~pm; // toggle am/pm after 12:59:59 rolls over
                    end else begin
                        hh <= inc_bcd_01_12(hh);
                    end
                end else begin
                    mm <= inc_bcd_00_59(mm);
                end
            end else begin
                ss <= inc_bcd_00_59(ss);
            end
        end
    end

endmodule