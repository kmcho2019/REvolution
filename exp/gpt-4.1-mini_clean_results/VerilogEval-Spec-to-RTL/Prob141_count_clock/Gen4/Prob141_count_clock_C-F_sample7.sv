module TopModule (
    input  clk,
    input  reset,
    input  ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

    // Inline combinational function to increment a BCD digit (0-9)
    // Returns next digit (0-9)
    function [3:0] bcd_inc_digit;
        input [3:0] digit;
        begin
            bcd_inc_digit = (digit == 4'd9) ? 4'd0 : digit + 4'd1;
        end
    endfunction

    // Increment seconds/minutes (BCD 00-59) inline without function call overhead
    // Returns next 8-bit BCD and indicates rollover (1 if rolled over from 59->00)
    function [8:0] bcd_inc_59_with_roll;
        input [7:0] val;
        reg [3:0] tens, units;
        reg rollover;
        reg [7:0] next_val;
        begin
            tens = val[7:4];
            units = val[3:0];
            if (tens == 4'd5 && units == 4'd9) begin
                next_val = 8'h00;
                rollover = 1'b1;
            end else if (units == 4'd9) begin
                next_val = {tens + 4'd1, 4'd0};
                rollover = 1'b0;
            end else begin
                next_val = {tens, units + 4'd1};
                rollover = 1'b0;
            end
            bcd_inc_59_with_roll = {rollover, next_val};
        end
    endfunction

    // Increment hour in 12-hour BCD format (01-12)
    // Returns next 8-bit BCD hour and flag if hour is currently 11 (for pm toggle)
    function [9:0] bcd_inc_hour_with_pm_flag;
        input [7:0] val;
        reg [3:0] tens, units;
        reg [7:0] next_val;
        reg pm_toggle_flag;
        begin
            pm_toggle_flag = (val == 8'h11); // Current hour is 11
            if (val == 8'h12)
                next_val = 8'h01;
            else begin
                tens = val[7:4];
                units = val[3:0];
                if (units == 4'd9) begin
                    next_val = {tens + 4'd1, 4'd0};
                end else begin
                    next_val = {tens, units + 4'd1};
                end
            end
            bcd_inc_hour_with_pm_flag = {pm_toggle_flag, next_val};
        end
    endfunction

    // Next state signals
    reg next_pm;
    reg [7:0] next_hh, next_mm, next_ss;

    always @* begin
        next_pm = pm;
        next_hh = hh;
        next_mm = mm;
        next_ss = ss;

        if (ena) begin
            // Increment seconds
            { // Use function returning rollover + next value
                reg sec_roll;
                reg [7:0] sec_next;
            } = bcd_inc_59_with_roll(ss);

            next_ss = sec_next;

            if (sec_roll) begin
                // Increment minutes on seconds rollover
                { 
                    reg min_roll;
                    reg [7:0] min_next;
                } = bcd_inc_59_with_roll(mm);

                next_mm = min_next;

                if (min_roll) begin
                    // Increment hour on minutes rollover
                    {
                        reg hour_pm_flag;
                        reg [7:0] hour_next;
                    } = bcd_inc_hour_with_pm_flag(hh);

                    next_hh = hour_next;

                    // Toggle PM on hour rollover from 11->12
                    if (hour_pm_flag) 
                        next_pm = ~pm;
                end
            end
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            pm <= 1'b0;    // AM
            hh <= 8'h12;   // 12
            mm <= 8'h00;
            ss <= 8'h00;
        end else begin
            pm <= next_pm;
            hh <= next_hh;
            mm <= next_mm;
            ss <= next_ss;
        end
    end

endmodule