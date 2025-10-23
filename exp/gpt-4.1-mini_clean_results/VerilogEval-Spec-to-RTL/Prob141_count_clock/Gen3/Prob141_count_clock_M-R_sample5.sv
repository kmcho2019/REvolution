module TopModule (
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

    // Internal signals for next time values
    reg [7:0] next_ss, next_mm, next_hh;
    reg next_pm;

    // Helpers for BCD increment of seconds/minutes (0-59)
    function [7:0] bcd_inc_59;
        input [7:0] val;
        reg [3:0] tens, units;
        begin
            tens = val[7:4];
            units = val[3:0];
            if (units == 4'd9) begin
                units = 4'd0;
                if (tens == 4'd5)
                    tens = 4'd0;
                else
                    tens = tens + 4'd1;
            end else begin
                units = units + 4'd1;
            end
            bcd_inc_59 = {tens, units};
        end
    endfunction

    // Check if BCD 8-bit value == 59
    function bcd_is_59;
        input [7:0] val;
        begin
            bcd_is_59 = (val == 8'h59);
        end
    endfunction

    // Increment hour in 12-hour BCD format (1 to 12)
    function [7:0] bcd_inc_hour;
        input [7:0] val;
        reg [3:0] tens, units;
        begin
            if (val == 8'h12)
                bcd_inc_hour = 8'h01;
            else begin
                tens = val[7:4];
                units = val[3:0];
                if (units == 4'd9) begin
                    units = 4'd0;
                    tens = tens + 4'd1;
                end else begin
                    units = units + 4'd1;
                end
                bcd_inc_hour = {tens, units};
            end
        end
    endfunction

    // Check if hour is 11 (to toggle PM on next increment)
    function hour_is_11;
        input [7:0] val;
        begin
            hour_is_11 = (val == 8'h11);
        end
    endfunction

    // Combinational next-state logic
    always @* begin
        next_pm = pm;
        next_ss = ss;
        next_mm = mm;
        next_hh = hh;

        if (ena) begin
            if (bcd_is_59(ss)) begin
                next_ss = 8'h00;
                if (bcd_is_59(mm)) begin
                    next_mm = 8'h00;
                    if (hour_is_11(hh))
                        next_pm = ~pm;
                    next_hh = bcd_inc_hour(hh);
                end else begin
                    next_mm = bcd_inc_59(mm);
                end
            end else begin
                next_ss = bcd_inc_59(ss);
            end
        end
    end

    // Sequential state update with synchronous reset
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