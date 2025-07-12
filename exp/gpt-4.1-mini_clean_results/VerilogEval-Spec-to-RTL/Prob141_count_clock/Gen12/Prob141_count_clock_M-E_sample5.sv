module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

// BCD digits for seconds
reg [3:0] ss_units, ss_tens;
// BCD digits for minutes
reg [3:0] mm_units, mm_tens;
// BCD digits for hours (01 to 12)
reg [3:0] hh_units, hh_tens;

// Helper function to increment BCD digit with max value
function [3:0] bcd_increment(input [3:0] digit, input [3:0] max_val);
    begin
        if (digit == max_val)
            bcd_increment = 4'd0;
        else
            bcd_increment = digit + 4'd1;
    end
endfunction

// Function to check if BCD digit equals max
function bcd_equals(input [3:0] digit, input [3:0] max_val);
    begin
        bcd_equals = (digit == max_val);
    end
endfunction

// Advance seconds BCD counter by one second when ena asserted
wire ss_rollover;
reg [3:0] ss_units_nxt, ss_tens_nxt;
always @* begin
    if (ena) begin
        if (ss_units == 4'd9) begin
            ss_units_nxt = 4'd0;
            if (ss_tens == 4'd5) begin
                ss_tens_nxt = 4'd0;
            end else begin
                ss_tens_nxt = ss_tens + 4'd1;
            end
        end else begin
            ss_units_nxt = ss_units + 4'd1;
            ss_tens_nxt = ss_tens;
        end
    end else begin
        ss_units_nxt = ss_units;
        ss_tens_nxt = ss_tens;
    end
end

assign ss_rollover = ena && (ss_units == 4'd9) && (ss_tens == 4'd5);

// Advance minutes BCD counter when seconds roll over
wire mm_rollover;
reg [3:0] mm_units_nxt, mm_tens_nxt;
always @* begin
    if (ss_rollover) begin
        if (mm_units == 4'd9) begin
            mm_units_nxt = 4'd0;
            if (mm_tens == 4'd5) begin
                mm_tens_nxt = 4'd0;
            end else begin
                mm_tens_nxt = mm_tens + 4'd1;
            end
        end else begin
            mm_units_nxt = mm_units + 4'd1;
            mm_tens_nxt = mm_tens;
        end
    end else begin
        mm_units_nxt = mm_units;
        mm_tens_nxt = mm_tens;
    end
end

assign mm_rollover = ss_rollover && (mm_units == 4'd9) && (mm_tens == 4'd5);

// Advance hours BCD counter (01 to 12) when minutes roll over
// Hours must count: 01,02,...,09,10,11,12 then back to 01
// So tens digit = 0 or 1, units digit from 0-9 with special rollovers
reg [3:0] hh_units_nxt, hh_tens_nxt;
reg pm_toggle;
always @* begin
    pm_toggle = 1'b0;
    if (mm_rollover) begin
        // Cases for hour rollover:
        // If current hour = 12 (hh_tens=1, hh_units=2), next hour = 01 and toggle pm
        if ((hh_tens == 4'd1) && (hh_units == 4'd2)) begin
            hh_tens_nxt = 4'd0;
            hh_units_nxt = 4'd1;
            pm_toggle = 1'b1;
        end else if (hh_units == 4'd9) begin
            // From 09 -> 10
            if (hh_tens == 4'd0) begin
                hh_tens_nxt = 4'd1;
                hh_units_nxt = 4'd0;
            end else begin
                // Should not happen in valid hours, but stay safe
                hh_tens_nxt = hh_tens;
                hh_units_nxt = hh_units;
            end
        end else begin
            // Regular increment units
            hh_units_nxt = hh_units + 4'd1;
            hh_tens_nxt = hh_tens;
        end
    end else begin
        hh_tens_nxt = hh_tens;
        hh_units_nxt = hh_units;
    end
end

// Sequential logic to update all counters and pm signal
always @(posedge clk) begin
    if (reset) begin
        // Initialize to 12:00:00 AM
        ss_units <= 4'd0;
        ss_tens  <= 4'd0;
        mm_units <= 4'd0;
        mm_tens  <= 4'd0;
        hh_units <= 4'd2; // 12
        hh_tens  <= 4'd1;
        pm       <= 1'b0; // AM
    end else begin
        ss_units <= ss_units_nxt;
        ss_tens  <= ss_tens_nxt;
        mm_units <= mm_units_nxt;
        mm_tens  <= mm_tens_nxt;
        hh_units <= hh_units_nxt;
        hh_tens  <= hh_tens_nxt;
        if (pm_toggle) begin
            pm <= ~pm;
        end
    end
end

// Combine BCD digits into outputs
always @* begin
    ss = {ss_tens, ss_units};
    mm = {mm_tens, mm_units};
    hh = {hh_tens, hh_units};
end

endmodule