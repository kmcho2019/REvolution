module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

// Helper functions for BCD increment with max limit
function [7:0] bcd_increment_2digit(input [7:0] val, input [7:0] max);
    reg [3:0] low, high;
    begin
        low = val[3:0];
        high = val[7:4];
        // Increment units digit
        if (low == 4'd9) begin
            low = 4'd0;
            // increment tens digit
            if (high == 4'd9) begin
                high = 4'd0;
            end else begin
                high = high + 4'd1;
            end
        end else begin
            low = low + 4'd1;
        end
        bcd_increment_2digit = {high, low};
        // If result > max, wrap to 0
        if (bcd_increment_2digit > max)
            bcd_increment_2digit = 8'd0;
    end
endfunction

function bcd_is_equal(input [7:0] val1, input [7:0] val2);
    begin
        bcd_is_equal = (val1 == val2);
    end
endfunction

// BCD increment second
// Since seconds and minutes max at 59, max = 8'h59 (0x59)
localparam [7:0] MAX_59 = 8'h59;

// Hours range: 01 to 12, represented in BCD.
// We'll store hours as two BCD digits, with 12h format: 01 to 12

// Increment hours in 12-hour BCD format:
// If hour == 12, next is 1 (0x01)
// else increment by 1
function [7:0] hour_next(input [7:0] curr_hour);
    reg [7:0] tmp;
    begin
        if (curr_hour == 8'h12)
            hour_next = 8'h01;
        else begin
            tmp = bcd_increment_2digit(curr_hour, 8'h12); // max 12 here but we wrap at 12 to 1 manually
            // if tmp is 0 or > 12 then wrap to 1
            if (tmp == 8'h00 || tmp > 8'h12)
                hour_next = 8'h01;
            else
                hour_next = tmp;
        end
    end
endfunction

// Internal signals to detect roll overs
wire sec_rollover;
wire min_rollover;
wire hr_rollover;

assign sec_rollover = bcd_is_equal(ss, MAX_59);
assign min_rollover = bcd_is_equal(mm, MAX_59);
assign hr_rollover  = (hh == 8'h11); // when hour changes from 11 to 12, toggle pm

always @(posedge clk) begin
    if (reset) begin
        // Reset to 12:00 AM
        pm <= 1'b0;
        hh <= 8'h12; // BCD 12
        mm <= 8'h00;
        ss <= 8'h00;
    end else if (ena) begin
        if (sec_rollover) begin
            ss <= 8'h00;
            if (min_rollover) begin
                mm <= 8'h00;
                // hour update
                if (hr_rollover) begin
                    hh <= 8'h12;
                    pm <= ~pm; // toggle pm at 12 after 11
                end else if (hh == 8'h12) begin
                    // after 12 comes 1
                    hh <= 8'h01;
                end else begin
                    // increment hour by 1
                    hh <= hour_next(hh);
                end
            end else begin
                mm <= bcd_increment_2digit(mm, MAX_59);
            end
        end else begin
            ss <= bcd_increment_2digit(ss, MAX_59);
        end
    end
end

endmodule