module TopModule(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

// Helper function to increment a BCD digit (4 bits) with limit
function [3:0] bcd_increment_0_9;
    input [3:0] digit;
    begin
        if (digit == 4'd9)
            bcd_increment_0_9 = 4'd0;
        else
            bcd_increment_0_9 = digit + 1;
    end
endfunction

// Helper function to increment a BCD digit with limit 0-5 (for tens of minutes/seconds)
function [3:0] bcd_increment_0_5;
    input [3:0] digit;
    begin
        if (digit == 4'd5)
            bcd_increment_0_5 = 4'd0;
        else
            bcd_increment_0_5 = digit + 1;
    end
endfunction

// Checks if BCD value equals a decimal number
function bcd_eq;
    input [7:0] bcd_val;
    input [7:0] decimal;
    reg [3:0] high, low;
    reg [3:0] dec_high, dec_low;
    begin
        high = bcd_val[7:4];
        low = bcd_val[3:0];
        dec_high = decimal / 10;
        dec_low = decimal % 10;
        bcd_eq = (high == dec_high) && (low == dec_low);
    end
endfunction

// Increment seconds
task increment_seconds;
    begin
        // Increment seconds units digit
        if (ss[3:0] == 4'd9) begin
            ss[3:0] = 4'd0;
            // Increment seconds tens digit
            if (ss[7:4] == 4'd5) begin
                ss[7:4] = 4'd0;
                increment_minutes();
            end else begin
                ss[7:4] = ss[7:4] + 4'd1;
            end
        end else begin
            ss[3:0] = ss[3:0] + 4'd1;
        end
    end
endtask

// Increment minutes
task increment_minutes;
    begin
        if (mm[3:0] == 4'd9) begin
            mm[3:0] = 4'd0;
            if (mm[7:4] == 4'd5) begin
                mm[7:4] = 4'd0;
                increment_hours();
            end else begin
                mm[7:4] = mm[7:4] + 4'd1;
            end
        end else begin
            mm[3:0] = mm[3:0] + 4'd1;
        end
    end
endtask

// Increment hours with 12-hour wrap and pm toggle
task increment_hours;
    reg [7:0] current_hour;
    reg [7:0] next_hour;
    begin
        current_hour = hh;
        // Convert BCD hour to decimal
        // Since only 01 to 12 valid, convert to decimal
        // high digit * 10 + low digit
        integer hour_dec;
        hour_dec = current_hour[7:4]*10 + current_hour[3:0];

        if (hour_dec == 11) begin
            // next hour is 12, toggle pm
            next_hour = 8'h12; // BCD 12
            pm = ~pm;
        end else if (hour_dec == 12) begin
            // next hour is 1
            next_hour = 8'h01;
            // pm unchanged
        end else begin
            // increment hour normally
            hour_dec = hour_dec + 1;
            next_hour[7:4] = hour_dec / 10;
            next_hour[3:0] = hour_dec % 10;
        end
        hh = next_hour;
    end
endtask

always @(posedge clk) begin
    if (reset) begin
        // Synchronous reset: time to 12:00:00 AM
        hh <= 8'h12; // 0x12 BCD = 12
        mm <= 8'h00;
        ss <= 8'h00;
        pm <= 1'b0; // AM
    end else if (ena) begin
        increment_seconds();
    end
end

endmodule