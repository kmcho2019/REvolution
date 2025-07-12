module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

// Separate BCD digit registers for seconds and minutes
reg [3:0] ss_units, ss_tens;
reg [3:0] mm_units, mm_tens;

// Hours stored as two BCD digits
reg [7:0] hh_reg; // 8-bit BCD for hours: upper nibble tens, lower nibble units

// Helper: increment BCD digit with max limit, rolls to zero after max
function [3:0] bcd_inc_digit(input [3:0] val, input [3:0] max);
begin
    if (val == max)
        bcd_inc_digit = 4'd0;
    else
        bcd_inc_digit = val + 4'd1;
end
endfunction

// Increment hours in BCD 12h format: 01 to 12
// On hour rollover from 11 to 12, toggle PM
function [7:0] hour_increment(input [7:0] curr_hour);
    reg [3:0] tens;
    reg [3:0] units;
begin
    tens = curr_hour[7:4];
    units = curr_hour[3:0];
    // Define some conditions
    // 11 = 0x11; 12 = 0x12; 09 = 0x09

    if (curr_hour == 8'h12) begin
        // After 12 comes 01
        hour_increment = 8'h01;
    end else if (curr_hour == 8'h09) begin
        // 09 to 10
        hour_increment = 8'h10;
    end else begin
        // Normal increment units digit
        if (units == 4'd9) begin
            units = 4'd0;
            tens = tens + 4'd1;
        end else begin
            units = units + 4'd1;
        end
        hour_increment = {tens, units};
    end
end
endfunction

// Signals for detecting rollover conditions
wire ss_units_max = (ss_units == 4'd9);
wire ss_tens_max  = (ss_tens  == 4'd5); // seconds tens max 5
wire mm_units_max = (mm_units == 4'd9);
wire mm_tens_max  = (mm_tens  == 4'd5);

wire hour_is_11 = (hh_reg == 8'h11);

always @(posedge clk) begin
    if (reset) begin
        pm       <= 1'b0;
        hh_reg   <= 8'h12; // 12 in BCD
        mm_tens  <= 4'd0;
        mm_units <= 4'd0;
        ss_tens  <= 4'd0;
        ss_units <= 4'd0;
    end else if (ena) begin
        // Increment seconds units
        if (ss_units_max) begin
            ss_units <= 4'd0;
            // Increment seconds tens
            if (ss_tens_max) begin
                ss_tens <= 4'd0;
                // Increment minutes units
                if (mm_units_max) begin
                    mm_units <= 4'd0;
                    // Increment minutes tens
                    if (mm_tens_max) begin
                        mm_tens <= 4'd0;
                        // Increment hours with 12h wrap
                        if (hour_is_11) begin
                            // Toggle PM on hour change 11 -> 12
                            pm <= ~pm;
                            hh_reg <= 8'h12;
                        end else if (hh_reg == 8'h12) begin
                            // After 12 comes 01
                            hh_reg <= 8'h01;
                        end else begin
                            hh_reg <= hour_increment(hh_reg);
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

// Output assignments: combine BCD digits into 8-bit busses
always @(*) begin
    hh = hh_reg;
    mm = {mm_tens, mm_units};
    ss = {ss_tens, ss_units};
end

endmodule