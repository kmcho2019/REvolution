module TopModule(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

// BCD ranges:
// Seconds and minutes: 00 to 59 -> upper nibble 0..5, lower nibble 0..9
// Hours: 01 to 12 -> two digits BCD: 0x01 to 0x12

// Internal helper function to increment a BCD digit (4 bits) with max 9
function [3:0] bcd_increment;
    input [3:0] digit;
    begin
        if(digit == 4'd9)
            bcd_increment = 4'd0;
        else
            bcd_increment = digit + 1;
    end
endfunction

// Increment a BCD byte representing 00..59 for mm/ss
function [7:0] bcd_inc_59;
    input [7:0] bcd_in;
    reg [3:0] upper, lower;
    begin
        upper = bcd_in[7:4];
        lower = bcd_in[3:0];
        if(lower == 4'd9) begin
            lower = 4'd0;
            if(upper == 4'd5)
                upper = 4'd0;
            else
                upper = upper + 1;
        end else begin
            lower = lower + 1;
        end
        bcd_inc_59 = {upper, lower};
    end
endfunction

// Check if bcd_in == 59
function bcd_is_59;
    input [7:0] bcd_in;
    begin
        bcd_is_59 = (bcd_in == 8'h59);
    end
endfunction

// Increment hours in BCD from 01 to 12
// Returns the incremented hour and a flag indicating if hour rolled over from 12 to 1
function [8:0] bcd_inc_hour;
    input [7:0] hour_in;
    reg [3:0] upper, lower;
    reg roll_over;
    reg [7:0] result;
    begin
        upper = hour_in[7:4];
        lower = hour_in[3:0];
        roll_over = 0;

        if(hour_in == 8'h12) begin
            // Roll over from 12 to 01
            result = 8'h01;
            roll_over = 1;
        end else begin
            // increment BCD hour normally
            if(lower == 4'd9) begin
                lower = 4'd0;
                upper = upper + 1;
            end else begin
                lower = lower + 1;
            end
            result = {upper, lower};
        end

        bcd_inc_hour = {roll_over, result};
    end
endfunction

always @(posedge clk) begin
    if (reset) begin
        // synchronous reset to 12:00 AM
        hh <= 8'h12;
        mm <= 8'h00;
        ss <= 8'h00;
        pm <= 1'b0;
    end else if (ena) begin
        // Increment seconds
        if (bcd_is_59(ss)) begin
            ss <= 8'h00;
            // Increment minutes
            if (bcd_is_59(mm)) begin
                mm <= 8'h00;
                // Increment hours
                // bcd_inc_hour returns {roll_over, new_hour}
                // roll_over toggles pm
                reg [8:0] inc_hour_res;
                inc_hour_res = bcd_inc_hour(hh);
                hh <= inc_hour_res[7:0];
                if (inc_hour_res[8]) begin
                    pm <= ~pm;
                end
            end else begin
                mm <= bcd_inc_59(mm);
            end
        end else begin
            ss <= bcd_inc_59(ss);
        end
    end
end

endmodule