module TopModule (
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

    // Increment a BCD digit from 0 to limit, wrap to 0 after limit
    function [3:0] bcd_inc;
        input [3:0] digit;
        input [3:0] limit;
        begin
            if (digit == limit)
                bcd_inc = 4'd0;
            else
                bcd_inc = digit + 4'd1;
        end
    endfunction

    // Check if BCD digit equals limit
    function bcd_is_max;
        input [3:0] digit;
        input [3:0] limit;
        begin
            bcd_is_max = (digit == limit);
        end
    endfunction

    // Increment a BCD byte representing 0-59 (minutes/seconds),
    // return new value and a flag if it rolled over (59->00)
    function [7:0] bcd_inc_59;
        input [7:0] value;
        begin
            if (value == 8'h59)
                bcd_inc_59 = 8'h00;
            else begin
                if (bcd_is_max(value[3:0],4'd9))
                    bcd_inc_59 = {bcd_inc(value[7:4],4'd5),4'd0};
                else
                    bcd_inc_59 = {value[7:4], value[3:0] + 4'd1};
            end
        end
    endfunction

    // Return 1 if the input 8-bit BCD value == 59
    function bcd_is_59;
        input [7:0] value;
        begin
            bcd_is_59 = (value == 8'h59);
        end
    endfunction

    // Increment hour in 12-hour BCD format (1 to 12)
    function [7:0] bcd_inc_hour;
        input [7:0] value;
        reg [3:0] tens, units;
        begin
            if (value == 8'h12)
                bcd_inc_hour = 8'h01;
            else begin
                tens = value[7:4];
                units = value[3:0];
                if (units == 4'd9) begin
                    tens = tens + 4'd1;
                    units = 4'd0;
                end else begin
                    units = units + 4'd1;
                end
                bcd_inc_hour = {tens, units};
            end
        end
    endfunction

    // Return 1 if hour is 11 (to detect PM toggle on next increment)
    function hour_is_11;
        input [7:0] value;
        begin
            hour_is_11 = (value == 8'h11);
        end
    endfunction

    always @(posedge clk) begin
        if (reset) begin
            pm <= 1'b0;    // AM
            hh <= 8'h12;   // 12
            mm <= 8'h00;
            ss <= 8'h00;
        end else if (ena) begin
            if (bcd_is_59(ss)) begin
                ss <= 8'h00;
                if (bcd_is_59(mm)) begin
                    mm <= 8'h00;
                    if (hour_is_11(hh)) begin
                        pm <= ~pm; // Toggle PM at 11->12 transition
                    end
                    hh <= bcd_inc_hour(hh);
                end else begin
                    mm <= bcd_inc_59(mm);
                end
            end else begin
                ss <= bcd_inc_59(ss);
            end
        end
    end

endmodule