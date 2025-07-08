module TopModule(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

    // BCD increment function for digits 0-9
    function [3:0] bcd_inc;
        input [3:0] digit;
        begin
            if(digit == 4'd9)
                bcd_inc = 4'd0;
            else
                bcd_inc = digit + 4'd1;
        end
    endfunction

    // Compare BCD two-digit values
    function is_bcd_equal;
        input [7:0] val;
        input [7:0] comp;
        begin
            is_bcd_equal = (val[7:4] == comp[7:4]) && (val[3:0] == comp[3:0]);
        end
    endfunction

    // Increment seconds and minutes BCD counter (0-59)
    function [7:0] inc_bcd_59;
        input [7:0] val; // two BCD digits
        reg [3:0] tens;
        reg [3:0] units;
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
            inc_bcd_59 = {tens, units};
        end
    endfunction

    // Check if BCD counter is 59
    function is_59;
        input [7:0] val;
        begin
            is_59 = (val[7:4] == 4'd5) && (val[3:0] == 4'd9);
        end
    endfunction

    // Check if hours BCD is 12 (0x12)
    function is_12;
        input [7:0] val;
        begin
            is_12 = (val[7:4] == 4'd1) && (val[3:0] == 4'd2);
        end
    endfunction

    // Check if hours BCD is 11 (0x11)
    function is_11;
        input [7:0] val;
        begin
            is_11 = (val[7:4] == 4'd1) && (val[3:0] == 4'd1);
        end
    endfunction

    // Check if hours BCD is 09 (0x09)
    function is_09;
        input [7:0] val;
        begin
            is_09 = (val[7:4] == 4'd0) && (val[3:0] == 4'd9);
        end
    endfunction

    // Increment hour function for 12-hour BCD clock
    function [7:0] inc_hour_12;
        input [7:0] val;
        begin
            if (is_09(val)) begin
                // 09 -> 10
                inc_hour_12 = 8'h10; // tens=1, units=0
            end else if (is_11(val)) begin
                // 11 -> 12
                inc_hour_12 = 8'h12;
            end else if (is_12(val)) begin
                // 12 -> 01
                inc_hour_12 = 8'h01;
            end else begin
                // Normal increment units digit
                // If units == 9 -> units=0 and tens+1; else units++
                if (val[3:0] == 4'd9) begin
                    inc_hour_12 = {(val[7:4] + 4'd1), 4'd0};
                end else begin
                    inc_hour_12 = {val[7:4], val[3:0] + 4'd1};
                end
            end
        end
    endfunction

    always @(posedge clk) begin
        if(reset) begin
            // Reset to 12:00:00 AM
            hh <= 8'h12;
            mm <= 8'h00;
            ss <= 8'h00;
            pm <= 1'b0;
        end else if(ena) begin
            // Increment seconds
            if (is_59(ss)) begin
                ss <= 8'h00;
                // Increment minutes
                if (is_59(mm)) begin
                    mm <= 8'h00;
                    // Increment hours
                    if (is_12(hh)) begin
                        hh <= 8'h01;
                        pm <= ~pm; // toggle pm at 12 -> 1
                    end else begin
                        hh <= inc_hour_12(hh);
                    end
                end else begin
                    mm <= inc_bcd_59(mm);
                end
            end else begin
                ss <= inc_bcd_59(ss);
            end
        end
    end

endmodule