module TopModule(
    input  wire clk,
    input  wire reset,
    input  wire ena,
    output reg  pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

// Helper function to increment BCD two-digit value with max limit
// Returns {next_value, carry_out}
function [8:0] bcd_increment;
    input [7:0] bcd_value;
    input [7:0] max_bcd; // max value before rollover
    reg [3:0] low_digit, high_digit;
    reg [3:0] next_low, next_high;
    begin
        low_digit = bcd_value[3:0];
        high_digit = bcd_value[7:4];

        if (low_digit == 4'd9) begin
            next_low = 4'd0;
            if (high_digit == max_bcd[7:4]) begin
                next_high = 4'd0;
            end else begin
                next_high = high_digit + 4'd1;
            end
        end else begin
            next_low = low_digit + 4'd1;
            next_high = high_digit;
        end

        // Check if value reached max_bcd, generate carry
        if (bcd_value == max_bcd)
            bcd_increment = {8'd0, 1'b1};
        else
            bcd_increment = { {next_high, next_low}, 1'b0 };
    end
endfunction

// We'll implement counters with explicit logic for clarity

// Increment seconds BCD (00-59)
function [9:0] inc_bcd_59;
    input [7:0] val;
    reg [3:0] low, high;
    reg carry_sec;
    reg [7:0] next_val;
    begin
        low = val[3:0];
        high = val[7:4];

        if (low == 4'd9) begin
            low = 4'd0;
            if (high == 4'd5) begin
                high = 4'd0;
                carry_sec = 1;
            end else begin
                high = high + 1;
                carry_sec = 0;
            end
        end else begin
            low = low + 1;
            carry_sec = 0;
        end
        next_val = {high, low};
        inc_bcd_59 = {next_val, carry_sec};
    end
endfunction

// Increment minutes BCD (00-59)
function [9:0] inc_bcd_59_min;
    input [7:0] val;
    reg [3:0] low, high;
    reg carry_min;
    reg [7:0] next_val;
    begin
        low = val[3:0];
        high = val[7:4];

        if (low == 4'd9) begin
            low = 4'd0;
            if (high == 4'd5) begin
                high = 4'd0;
                carry_min = 1;
            end else begin
                high = high + 1;
                carry_min = 0;
            end
        end else begin
            low = low + 1;
            carry_min = 0;
        end
        next_val = {high, low};
        inc_bcd_59_min = {next_val, carry_min};
    end
endfunction

// Increment hours BCD 12-hour format (01-12)
// Returns {next_val, carry_hour} carry_hour indicates roll from 12->1
function [9:0] inc_bcd_hour;
    input [7:0] val;
    reg [3:0] low, high;
    reg carry_hour;
    reg [7:0] next_val;
    begin
        low = val[3:0];
        high = val[7:4];
        carry_hour = 0;

        if (val == 8'h12) begin
            // 12 -> 01 with carry
            next_val = 8'h01;
            carry_hour = 1;
        end else if (low == 4'd9) begin
            // Low digit rollover from 9 to 0, increment high digit
            low = 4'd0;
            high = high + 4'd1;
            next_val = {high, low};
        end else begin
            // Normal increment
            low = low + 4'd1;
            next_val = {high, low};
        end

        inc_bcd_hour = {next_val, carry_hour};
    end
endfunction

always @(posedge clk) begin
    if (reset) begin
        // Synchronous reset to 12:00:00 AM
        hh <= 8'h12; // 0x12 is BCD for 12
        mm <= 8'h00;
        ss <= 8'h00;
        pm <= 1'b0;
    end else if (ena) begin
        // Increment seconds
        reg [8:0] sec_inc;
        reg [8:0] min_inc;
        reg [8:0] hour_inc;

        sec_inc = inc_bcd_59(ss);
        ss <= sec_inc[8:1];

        if (sec_inc[0]) begin
            // seconds rolled over, increment minutes
            min_inc = inc_bcd_59_min(mm);
            mm <= min_inc[8:1];

            if (min_inc[0]) begin
                // minutes rolled over, increment hours
                hour_inc = inc_bcd_hour(hh);
                hh <= hour_inc[8:1];

                if (hour_inc[0]) begin
                    // hours rolled from 12 to 1, toggle pm
                    pm <= ~pm;
                end
            end
        end
    end
end

endmodule