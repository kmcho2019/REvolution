module TopModule (
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

    // Function to increment a BCD digit (4 bits), returning new digit and carry
    function [5:0] bcd_inc4; // 5:0 = {carry, 4-bit digit}
        input [3:0] digit;
        begin
            if (digit == 4'd9)
                bcd_inc4 = {1'b1, 4'd0};
            else
                bcd_inc4 = {1'b0, digit + 1'b1};
        end
    endfunction

    // Function to increment a BCD byte (two digits), returning new byte and carry
    function [11:0] bcd_inc8; // 11:0 = {carry, 8-bit bcd}
        input [7:0] bcd;
        reg [5:0] low_inc;
        reg [5:0] high_inc;
        begin
            low_inc = bcd_inc4(bcd[3:0]);
            if (low_inc[5] == 1'b1) // carry from low digit
                high_inc = bcd_inc4(bcd[7:4]);
            else
                high_inc = {1'b0, bcd[7:4]};
            bcd_inc8 = {high_inc[5], high_inc[4:1], low_inc[4:1]};
        end
    endfunction

    // Increment seconds, minutes, and hours with correct rollover
    // Since 60 decimal = 0x60 in BCD, we must detect when BCD reaches 60

    // Helper function to check if BCD byte equals 60 (i.e. 0x60)
    function is_60;
        input [7:0] bcd;
        begin
            is_60 = (bcd[7:4] == 4'd6) && (bcd[3:0] == 4'd0);
        end
    endfunction

    // Helper function to check if hour BCD equals 12 (0x12)
    function is_12;
        input [7:0] bcd;
        begin
            is_12 = (bcd[7:4] == 4'd1) && (bcd[3:0] == 4'd2);
        end
    endfunction

    // Helper function to check if hour BCD equals 11 (0x11)
    // Used to detect increment from 11 to 12, to toggle PM later
    function is_11;
        input [7:0] bcd;
        begin
            is_11 = (bcd[7:4] == 4'd1) && (bcd[3:0] == 4'd1);
        end
    endfunction

    // Helper function to increment hours with 12-hour logic
    function [8:0] inc_hour; // 8-bit bcd + 1-bit pm_toggle_flag
        input [7:0] hour_in;
        begin
            // We increment hour from 1 to 12
            // Hours go: 01, 02, ..., 11, 12, 01, ...
            // On increment from 11->12, pm toggles on next increment (12->1)
            if (hour_in == 8'h12) begin
                // wrap to 1
                inc_hour = {1'b1, 8'h01}; // pm toggle flag=1
            end else begin
                // increment BCD hour by one
                reg [5:0] low_inc;
                reg [5:0] high_inc;
                low_inc = bcd_inc4(hour_in[3:0]);
                if (low_inc[5]) // carry from low digit
                    high_inc = bcd_inc4(hour_in[7:4]);
                else
                    high_inc = {1'b0, hour_in[7:4]};
                inc_hour = {1'b0, {high_inc[4:1], low_inc[4:1]}};
            end
        end
    endfunction

    always @(posedge clk) begin
        if (reset) begin
            // synchronous reset: 12:00:00 AM
            hh <= 8'h12; // 12
            mm <= 8'h00;
            ss <= 8'h00;
            pm <= 1'b0; // AM
        end else if (ena) begin
            // increment seconds
            reg [5:0] low_inc_s;
            reg [5:0] high_inc_s;
            reg [5:0] low_inc_m;
            reg [5:0] high_inc_m;
            reg [8:0] inc_h_result;
            reg pm_next;
            // Increment seconds low digit
            low_inc_s = bcd_inc4(ss[3:0]);
            if (low_inc_s[5])
                high_inc_s = bcd_inc4(ss[7:4]);
            else
                high_inc_s = {1'b0, ss[7:4]};
            ss = {high_inc_s[4:1], low_inc_s[4:1]};

            if (is_60(ss)) begin
                ss <= 8'h00;
                // increment minutes
                low_inc_m = bcd_inc4(mm[3:0]);
                if (low_inc_m[5])
                    high_inc_m = bcd_inc4(mm[7:4]);
                else
                    high_inc_m = {1'b0, mm[7:4]};
                mm = {high_inc_m[4:1], low_inc_m[4:1]};
                if (is_60(mm)) begin
                    mm <= 8'h00;
                    // increment hours
                    inc_h_result = inc_hour(hh);
                    hh <= inc_h_result[7:0];
                    // toggle pm if inc_h_result[8] is 1
                    pm_next = pm;
                    if (inc_h_result[8])
                        pm_next = ~pm;
                    pm <= pm_next;
                end
            end
        end
    end

endmodule