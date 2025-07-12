module TopModule(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

    // BCD digit ranges: 0-9 per digit
    // Hours BCD: hh = {hh_tens, hh_units} representing 01 to 12
    // Minutes BCD: mm = {mm_tens, mm_units} 00 to 59
    // Seconds BCD: ss = {ss_tens, ss_units} 00 to 59
    
    // Helper functions: increment BCD digits with rollovers
    
    // Increment BCD two digit (00-59 or 00-99)
    function [7:0] bcd_increment_59(input [7:0] bcd);
        reg [3:0] tens;
        reg [3:0] units;
        begin
            tens = bcd[7:4];
            units = bcd[3:0];
            if(units == 4'd9) begin
                units = 4'd0;
                if(tens == 4'd5) begin
                    tens = 4'd0;
                end else begin
                    tens = tens + 1'b1;
                end
            end else begin
                units = units + 1'b1;
            end
            bcd_increment_59 = {tens, units};
        end
    endfunction

    // Increment hour BCD from 01 to 12 with wrap and pm toggle
    // Input: current hh in BCD
    // Output: next hh in BCD and pm update indication
    // Note: hh digits are 01 to 12 (01-09, 10,11,12)
    function [7:0] bcd_hour_increment(input [7:0] curr_hh);
        reg [3:0] tens;
        reg [3:0] units;
        reg [7:0] next_hh;
        begin
            tens = curr_hh[7:4];
            units = curr_hh[3:0];
            // current hour decimal value
            // Convert BCD to decimal integer
            // decimal_hour = tens*10 + units
            // Next hour:
            // if current == 12, next is 1
            // else increment by 1
            if((tens == 1 && units == 2)) begin
                // wrap to 01
                next_hh = 8'b00000001; // 0x01
            end else if (units == 4'd9) begin
                // units rollover
                tens = tens + 1'b1;
                units = 4'd0;
                next_hh = {tens, units};
            end else begin
                units = units + 1'b1;
                next_hh = {tens, units};
            end
            bcd_hour_increment = next_hh;
        end
    endfunction

    // Helper to check if hh == 12
    wire hour_is_12 = (hh[7:4] == 4'd1 && hh[3:0] == 4'd2);

    always @(posedge clk) begin
        if (reset) begin
            // synchronous reset to 12:00:00 AM
            hh <= 8'b00010010; // 0x12 decimal 12
            mm <= 8'b00000000; // 00
            ss <= 8'b00000000; // 00
            pm <= 1'b0;        // AM = 0
        end else if (ena) begin
            // increment seconds
            if (ss == 8'b01011001) begin // 59 seconds BCD = 0x59
                ss <= 8'b00000000; // 00 seconds
                // increment minutes
                if (mm == 8'b01011001) begin // 59 minutes
                    mm <= 8'b00000000; // 00 minutes
                    // increment hour and toggle pm if hour wraps past 12
                    if (hour_is_12) begin
                        hh <= 8'b00000001; // 01 hour
                        pm <= ~pm;
                    end else begin
                        hh <= bcd_hour_increment(hh);
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