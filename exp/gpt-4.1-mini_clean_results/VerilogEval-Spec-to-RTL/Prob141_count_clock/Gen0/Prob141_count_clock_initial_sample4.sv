module TopModule (
    input        clk,
    input        reset,
    input        ena,
    output reg   pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

// Function to increment a BCD digit (0-9)
function [3:0] bcd_inc_0to9;
    input [3:0] bcd_in;
    begin
        if (bcd_in == 4'd9)
            bcd_inc_0to9 = 4'd0;
        else
            bcd_inc_0to9 = bcd_in + 4'd1;
    end
endfunction

// Increment BCD 0-5 for minute/second tens digit
function [3:0] bcd_inc_0to5;
    input [3:0] bcd_in;
    begin
        if (bcd_in == 4'd5)
            bcd_inc_0to5 = 4'd0;
        else
            bcd_inc_0to5 = bcd_in + 4'd1;
    end
endfunction

// Check if BCD is 0-9 valid
function bcd_is_9;
    input [3:0] bcd_in;
    begin
        bcd_is_9 = (bcd_in == 4'd9);
    end
endfunction

// Check if BCD minutes/seconds are 59 (tens=5 and ones=9)
wire sec_ones_max = (ss[3:0] == 4'd9);
wire sec_tens_max = (ss[7:4] == 4'd5);
wire sec_max = sec_ones_max && sec_tens_max;

wire min_ones_max = (mm[3:0] == 4'd9);
wire min_tens_max = (mm[7:4] == 4'd5);
wire min_max = min_ones_max && min_tens_max;

// For hours BCD, the valid range is 01 to 12.
// Since hh is 8 bits (tens and ones), and valid tens are 0 or 1,
// and ones are 0-9 but with restrictions:
// 01 to 09: tens=0, ones=1..9
// 10 to 12: tens=1, ones=0..2

// We'll implement hour increment logic carefully:

// Extract hour digits
wire [3:0] hh_tens = hh[7:4];
wire [3:0] hh_ones = hh[3:0];

// Check if current hour is 12 (tens=1, ones=2)
wire hh_is_12 = (hh_tens == 4'd1) && (hh_ones == 4'd2);

always @(posedge clk) begin
    if (reset) begin
        // reset to 12:00:00 AM
        ss <= 8'h00; // 00 seconds
        mm <= 8'h00; // 00 minutes
        hh <= 8'h12; // 12 hours
        pm <= 1'b0;  // AM
    end else if (ena) begin
        // increment seconds
        if (sec_max) begin
            // seconds rollover to 00, increment minutes
            ss <= 8'h00;
            if (min_max) begin
                // minutes rollover to 00, increment hours
                mm <= 8'h00;
                if (hh_is_12) begin
                    // hour rollover from 12 to 1, toggle pm
                    hh <= 8'h01;
                    pm <= ~pm;
                end else begin
                    // increment hours carefully

                    // For hours:
                    // If tens == 0 (hours 01 to 09)
                    // increment ones digit
                    // If ones == 9 (which would be 09), then next is 10 (tens=1, ones=0)
                    if (hh_tens == 4'd0) begin
                        if (hh_ones == 4'd9) begin
                            hh <= 8'h10; // 10 hours
                        end else begin
                            hh <= {4'd0, hh_ones + 4'd1};
                        end
                    end else begin
                        // tens == 1, ones = 0..2
                        // increment ones digit until 2, then rollover to 1
                        if (hh_ones < 4'd2) begin
                            hh <= {4'd1, hh_ones + 4'd1};
                        end
                        // if ones == 2 handled above by rollover to 1 in hh_is_12 check
                    end
                end
            end else begin
                // increment minutes normally
                // increment ones digit
                if (min_ones_max) begin
                    mm <= {bcd_inc_0to5(mm[7:4]), 4'd0};
                end else begin
                    mm <= {mm[7:4], mm[3:0] + 4'd1};
                end
                // seconds already set to 00 above
            end
        end else begin
            // increment seconds normally
            if (sec_ones_max) begin
                ss <= {bcd_inc_0to5(ss[7:4]), 4'd0};
            end else begin
                ss <= {ss[7:4], ss[3:0] + 4'd1};
            end
        end
    end
end

endmodule