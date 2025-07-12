module TopModule (
    input        clk,
    input        reset,
    input        ena,
    output reg   pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

    // BCD increment function with limit detection
    function [7:0] bcd_increment_59;
        input [7:0] val; // two-digit BCD (tens:val[7:4], units:val[3:0])
        reg [3:0] units, tens;
        begin
            units = val[3:0];
            tens  = val[7:4];
            if (units == 4'd9) begin
                units = 4'd0;
                if (tens == 4'd5)
                    tens = 4'd0;
                else
                    tens = tens + 1;
            end else begin
                units = units + 1;
            end
            bcd_increment_59 = {tens, units};
        end
    endfunction

    // Returns 1 if val == 59 BCD
    function is_59;
        input [7:0] val;
        begin
            is_59 = (val == 8'h59);
        end
    endfunction

    // Hours increment in 12-hour BCD (01 to 12)
    // Returns next hour BCD and flag indicating if hour wrapped (i.e., from 12 to 1)
    function [8:0] hour_increment;
        input [7:0] val; // hh in BCD
        reg [3:0] tens, units;
        reg       wrapped;
        reg [7:0] next_hh;
        begin
            tens = val[7:4];
            units = val[3:0];
            wrapped = 0;

            if (val == 8'h12) begin
                // wrap around to 01
                next_hh = 8'h01;
                wrapped = 1;
            end else if (tens == 4'd0) begin
                // from 01..09 increment units
                if (units == 4'd9) begin
                    // units rolling over from 9 to 0, tens becomes 1
                    next_hh = 8'h10;
                end else begin
                    next_hh = {tens, units + 4'd1};
                end
            end else begin
                // tens == 1, units from 0..1 (only 10 or 11 possible)
                // increment units (from 0 to 1, from 1 to 2 triggers wrap)
                if (units == 4'd1) begin
                    // going 11 -> 12
                    next_hh = 8'h12;
                end else if (units == 4'd2) begin
                    // if somehow 12 increment, wrap to 1 (shouldn't happen here)
                    next_hh = 8'h01;
                    wrapped = 1;
                end else begin
                    // units 0..? increment
                    next_hh = {tens, units + 4'd1};
                end
            end
            hour_increment = {wrapped, next_hh};
        end
    endfunction

    always @(posedge clk) begin
        if (reset) begin
            // Synchronous reset to 12:00:00 AM
            pm <= 1'b0;
            hh <= 8'h12; // 12 in BCD
            mm <= 8'h00;
            ss <= 8'h00;
        end else if (ena) begin
            // Increment seconds
            if (is_59(ss)) begin
                ss <= 8'h00;
                // increment minutes
                if (is_59(mm)) begin
                    mm <= 8'h00;
                    // increment hours
                    // use hour_increment function to get next hour and wrapped flag
                    reg [8:0] hr_inc;
                    hr_inc = hour_increment(hh);
                    hh <= hr_inc[7:0];
                    if (hr_inc[8]) begin
                        // Hour wrapped from 12 -> 1, so toggle PM
                        pm <= ~pm;
                    end
                end else begin
                    mm <= bcd_increment_59(mm);
                end
            end else begin
                ss <= bcd_increment_59(ss);
            end
        end
    end

endmodule