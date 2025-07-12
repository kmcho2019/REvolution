module TopModule (
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

    // Increment a single BCD digit with limit, wrap to zero after limit
    function [3:0] bcd_inc;
        input [3:0] digit;
        input [3:0] limit;
        begin
            bcd_inc = (digit == limit) ? 4'd0 : digit + 4'd1;
        end
    endfunction

    // Check if a BCD digit equals limit
    function bcd_is_max;
        input [3:0] digit;
        input [3:0] limit;
        begin
            bcd_is_max = (digit == limit);
        end
    endfunction

    // Increment a BCD byte representing 00-59 and report rollover
    function [7:0] bcd_inc_59;
        input [7:0] val;
        begin
            if (val == 8'h59) begin
                bcd_inc_59 = 8'h00;
            end else if (bcd_is_max(val[3:0],4'd9)) begin
                bcd_inc_59 = {bcd_inc(val[7:4],4'd5), 4'd0};
            end else begin
                bcd_inc_59 = {val[7:4], val[3:0] + 4'd1};
            end
        end
    endfunction

    // Increment hour in 12-hour BCD format (01 to 12)
    function [7:0] bcd_inc_hour;
        input [7:0] val;
        reg [3:0] tens, units;
        begin
            if (val == 8'h12) begin
                bcd_inc_hour = 8'h01;
            end else begin
                tens = val[7:4];
                units = val[3:0];
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

    // Detect if hour is 11 (for pm toggle on next hour increment)
    function hour_is_11;
        input [7:0] val;
        begin
            hour_is_11 = (val == 8'h11);
        end
    endfunction

    // Next state signals
    reg next_pm;
    reg [7:0] next_hh, next_mm, next_ss;

    always @* begin
        // Defaults: hold current values
        next_pm = pm;
        next_hh = hh;
        next_mm = mm;
        next_ss = ss;

        if (ena) begin
            if (ss == 8'h59) begin
                next_ss = 8'h00;
                if (mm == 8'h59) begin
                    next_mm = 8'h00;
                    // Toggle pm if hour is 11 before incrementing
                    if (hour_is_11(hh)) begin
                        next_pm = ~pm;
                    end
                    next_hh = bcd_inc_hour(hh);
                end else begin
                    next_mm = bcd_inc_59(mm);
                end
            end else begin
                next_ss = bcd_inc_59(ss);
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