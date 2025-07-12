module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

// Internal digit registers for hours, minutes, seconds
// Separate units and tens digits as 4-bit BCD
reg [3:0] ss_units, ss_tens;
reg [3:0] mm_units, mm_tens;
reg [3:0] hh_units, hh_tens;

// Helper function: increment BCD digit with max limit
function [3:0] bcd_inc_digit(input [3:0] val, input [3:0] max);
begin
    if (val == max)
        bcd_inc_digit = 4'd0;
    else
        bcd_inc_digit = val + 4'd1;
end
endfunction

// Check if BCD digit equals max
function bcd_eq(input [3:0] val, input [3:0] cmp);
begin
    bcd_eq = (val == cmp);
end
endfunction

// Conditions for rollovers
wire ss_units_rollover = bcd_eq(ss_units, 4'd9);
wire ss_tens_rollover  = bcd_eq(ss_tens, 4'd5); // max 5 for seconds tens digit
wire mm_units_rollover = bcd_eq(mm_units, 4'd9);
wire mm_tens_rollover  = bcd_eq(mm_tens, 4'd5);

// Hour counting rules:
// Hours units digit: 0-9 normally
// Hours tens digit: 0 or 1
// Hours max: 12, i.e. tens=1 and units=2 max
// Special: after 12 comes 1 (0x01)

// Check if hour is 11 (tens=1, units=1)
wire hour_is_11 = (hh_tens == 4'd1) && (hh_units == 4'd1);
// Check if hour is 12 (tens=1, units=2)
wire hour_is_12 = (hh_tens == 4'd1) && (hh_units == 4'd2);
// Check if hour is 09 (tens=0, units=9)
wire hour_is_09 = (hh_tens == 4'd0) && (hh_units == 4'd9);

always @(posedge clk) begin
    if (reset) begin
        // Reset to 12:00:00 AM
        pm       <= 1'b0;
        hh_tens  <= 4'd1;
        hh_units <= 4'd2;
        mm_tens  <= 4'd0;
        mm_units <= 4'd0;
        ss_tens  <= 4'd0;
        ss_units <= 4'd0;
    end else if (ena) begin
        // Increment seconds units
        if (ss_units_rollover) begin
            ss_units <= 4'd0;
            // Increment seconds tens
            if (ss_tens_rollover) begin
                ss_tens <= 4'd0;
                // Increment minutes units
                if (mm_units_rollover) begin
                    mm_units <= 4'd0;
                    // Increment minutes tens
                    if (mm_tens_rollover) begin
                        mm_tens <= 4'd0;
                        // Increment hour units and tens with special rules
                        if (hour_is_11) begin
                            // From 11 to 12, toggle pm and set hour to 12
                            pm <= ~pm;
                            hh_tens  <= 4'd1;
                            hh_units <= 4'd2;
                        end else if (hour_is_12) begin
                            // From 12 to 01
                            hh_tens  <= 4'd0;
                            hh_units <= 4'd1;
                        end else if (hour_is_09) begin
                            // From 09 to 10
                            hh_tens  <= 4'd1;
                            hh_units <= 4'd0;
                        end else begin
                            // Normal increment hours units
                            if (hh_units == 4'd9) begin
                                hh_units <= 4'd0;
                                hh_tens <= hh_tens + 4'd1; // will only go from 0 to 1 here
                            end else begin
                                hh_units <= hh_units + 4'd1;
                            end
                        end
                    end else begin
                        mm_tens <= mm_tens + 4'd1;
                    end
                end else begin
                    mm_units <= mm_units + 4'd1;
                end
            end else begin
                ss_tens <= ss_tens + 4'd1;
            end
        end else begin
            ss_units <= ss_units + 4'd1;
        end
    end
end

// Combine digits into outputs
always @(*) begin
    hh = {hh_tens, hh_units};
    mm = {mm_tens, mm_units};
    ss = {ss_tens, ss_units};
end

endmodule