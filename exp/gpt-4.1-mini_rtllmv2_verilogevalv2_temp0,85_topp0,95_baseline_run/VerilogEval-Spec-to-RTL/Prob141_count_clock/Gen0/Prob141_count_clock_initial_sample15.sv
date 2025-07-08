module TopModule (
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

// Extract digits of BCD for convenience
wire [3:0] ss_ones = ss[3:0];
wire [3:0] ss_tens = ss[7:4];
wire [3:0] mm_ones = mm[3:0];
wire [3:0] mm_tens = mm[7:4];
wire [3:0] hh_ones = hh[3:0];
wire [3:0] hh_tens = hh[7:4];

// Increment BCD digit with wrap around at 9
function [3:0] bcd_inc(input [3:0] digit);
    begin
        if (digit == 4'd9)
            bcd_inc = 4'd0;
        else
            bcd_inc = digit + 1;
    end
endfunction

// Check if BCD digit is 9
function is_bcd_9(input [3:0] digit);
    begin
        is_bcd_9 = (digit == 4'd9);
    end
endfunction

// Increment seconds BCD from 00 to 59
// returns 1 if rolled over to 00, else 0
function sec_inc(input [7:0] sec_in);
    reg [3:0] tens, ones;
    begin
        tens = sec_in[7:4];
        ones = sec_in[3:0];
        if (ones == 4'd9) begin
            ones = 4'd0;
            if (tens == 4'd5) begin
                tens = 4'd0;
                sec_inc = 1; // rollover to 00
            end else begin
                tens = tens + 1;
                sec_inc = 0;
            end
        end else begin
            ones = ones + 1;
            sec_inc = 0;
        end
    end
endfunction

// Increment minutes BCD from 00 to 59
// returns 1 if rolled over to 00, else 0
function min_inc(input [7:0] min_in);
    reg [3:0] tens, ones;
    begin
        tens = min_in[7:4];
        ones = min_in[3:0];
        if (ones == 4'd9) begin
            ones = 4'd0;
            if (tens == 4'd5) begin
                tens = 4'd0;
                min_inc = 1; // rollover to 00
            end else begin
                tens = tens + 1;
                min_inc = 0;
            end
        end else begin
            ones = ones + 1;
            min_inc = 0;
        end
    end
endfunction

// Increment hours BCD from 01 to 12
// returns 1 if hour rolls from 11 to 12 (to toggle pm)
function hour_inc(input [7:0] hour_in);
    reg [3:0] tens, ones;
    reg [7:0] new_hour;
    begin
        tens = hour_in[7:4];
        ones = hour_in[3:0];

        // hour is from 01 to 12 in BCD
        // Increment by 1, wrap after 12 to 01
        if (tens == 4'd0) begin
            // hours 01-09
            if (ones == 4'd9) begin
                // roll from 09 to 10
                ones = 4'd0;
                tens = 4'd1;
                hour_inc = 0;
            end else begin
                ones = ones + 1;
                hour_inc = 0;
            end
        end else if (tens == 4'd1) begin
            // hours 10-12
            if (ones == 4'd2) begin
                // roll from 12 to 01
                ones = 4'd1;
                tens = 4'd0;
                hour_inc = 1; // toggle pm when hour rolls 11->12, so toggling at 12->01 is late
                               // Let's toggle pm on 11->12 increment (so need to check below)
            end else begin
                ones = ones + 1;
                if (ones == 4'd2) begin
                    // just incremented from 11 to 12, toggle pm
                    hour_inc = 1;
                end else begin
                    hour_inc = 0;
                end
            end
        end else begin
            // invalid hour BCD, reset to 12 for safety
            tens = 4'd1;
            ones = 4'd2;
            hour_inc = 0;
        end
    end
endfunction

// Because the above hour_inc function returns 1 when the hour increments from 11 to 12,
// we will implement hour increment manually for clarity.

reg [7:0] ss_next, mm_next, hh_next;
reg pm_next;
reg rollover_sec, rollover_min, toggle_pm;

always @(posedge clk) begin
    if (reset) begin
        pm <= 1'b0;         // AM = 0
        hh <= 8'h12;        // 12 decimal is 0x12 in BCD
        mm <= 8'h00;
        ss <= 8'h00;
    end else if (ena) begin
        // increment seconds
        if (ss_ones == 4'd9) begin
            if (ss_tens == 4'd5) begin
                // seconds rollover to 00
                ss <= 8'h00;
                // increment minutes
                if (mm_ones == 4'd9) begin
                    if (mm_tens == 4'd5) begin
                        // minutes rollover to 00
                        mm <= 8'h00;
                        // increment hours
                        // Extract current hour digits
                        reg [3:0] h_tens, h_ones;
                        h_tens = hh_tens;
                        h_ones = hh_ones;
                        if (h_tens == 4'd0) begin
                            if (h_ones == 4'd9) begin
                                // 09 -> 10
                                hh <= 8'h10;
                                toggle_pm <= 0;
                            end else begin
                                hh <= {h_tens, h_ones + 1};
                                toggle_pm <= 0;
                            end
                        end else if (h_tens == 4'd1) begin
                            if (h_ones == 4'd1) begin
                                // 11 -> 12
                                hh <= 8'h12;
                                toggle_pm <= 1; // toggle pm on 11->12 increment
                            end else if (h_ones == 4'd2) begin
                                // 12 -> 01
                                hh <= 8'h01;
                                toggle_pm <= 0;
                            end else begin
                                // invalid hour, reset to 12
                                hh <= 8'h12;
                                toggle_pm <= 0;
                            end
                        end else begin
                            // invalid hour, reset to 12
                            hh <= 8'h12;
                            toggle_pm <= 0;
                        end
                        if (toggle_pm)
                            pm <= ~pm;
                    end else begin
                        // increment minutes tens digit
                        mm <= {mm_tens + 1, 4'd0};
                    end
                end else begin
                    // increment minutes ones digit
                    mm <= {mm_tens, mm_ones + 1};
                end
            end else begin
                // increment seconds tens digit
                ss <= {ss_tens + 1, 4'd0};
            end
        end else begin
            // increment seconds ones digit
            ss <= {ss_tens, ss_ones + 1};
        end
    end
end

endmodule