module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

// Internal BCD digits for hours, minutes, and seconds
reg [3:0] hh_tens, hh_units; // hour tens and units (for 01 to 12)
reg [3:0] mm_tens, mm_units; // minute tens and units (00 to 59)
reg [3:0] ss_tens, ss_units; // second tens and units (00 to 59)

// Helper function: increment a BCD digit (0-9) with rollover to 0
function [3:0] bcd_inc(input [3:0] digit);
    begin
        if (digit == 4'd9)
            bcd_inc = 4'd0;
        else
            bcd_inc = digit + 4'd1;
    end
endfunction

// Helper function: check if BCD digit equals a value
function is_bcd_eq(input [3:0] digit, input [3:0] val);
    begin
        is_bcd_eq = (digit == val);
    end
endfunction

// Determine if hour is 12 (1,2 is tens, units)
wire hour_is_12 = (hh_tens == 4'd1) && (hh_units == 4'd2);
wire hour_is_11 = (hh_tens == 4'd1) && (hh_units == 4'd1);

// Logic to increment hour BCD properly from 01 to 12 and wrap to 01
// Special case when hour is 12, increment rolls back to 01.
task hour_increment(
    input  [3:0] curr_tens,
    input  [3:0] curr_units,
    output [3:0] next_tens,
    output [3:0] next_units
);
    begin
        if (curr_tens == 4'd0) begin
            // hours 01-09
            if (curr_units == 4'd9) begin
                next_tens  = 4'd1; // go to 10
                next_units = 4'd0;
            end else begin
                next_tens  = curr_tens;
                next_units = curr_units + 4'd1;
            end
        end else if (curr_tens == 4'd1) begin
            // hours 10-12
            if (curr_units == 4'd2) begin
                // 12 -> 01 wrap
                next_tens  = 4'd0;
                next_units = 4'd1;
            end else begin
                next_tens  = curr_tens;
                next_units = curr_units + 4'd1;
            end
        end else begin
            // Invalid state, reset to 01
            next_tens  = 4'd0;
            next_units = 4'd1;
        end
    end
endtask

always @(posedge clk) begin
    if (reset) begin
        // Reset clock to 12:00:00 AM
        hh_tens  <= 4'd1;
        hh_units <= 4'd2;
        mm_tens  <= 4'd0;
        mm_units <= 4'd0;
        ss_tens  <= 4'd0;
        ss_units <= 4'd0;
        pm       <= 1'b0; // AM
    end else if (ena) begin
        // Increment seconds units
        if (ss_units == 4'd9) begin
            ss_units <= 4'd0;
            // Increment seconds tens
            if (ss_tens == 4'd5) begin
                ss_tens <= 4'd0;
                // Increment minutes units
                if (mm_units == 4'd9) begin
                    mm_units <= 4'd0;
                    // Increment minutes tens
                    if (mm_tens == 4'd5) begin
                        mm_tens <= 4'd0;
                        // Increment hours
                        reg [3:0] next_hh_tens, next_hh_units;
                        hour_increment(hh_tens, hh_units, next_hh_tens, next_hh_units);

                        // Toggle pm if hour rolls from 11 to 12
                        if (hour_is_11) begin
                            pm <= ~pm;
                        end

                        hh_tens  <= next_hh_tens;
                        hh_units <= next_hh_units;
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

// Assign outputs directly from BCD registers
always @(*) begin
    hh = {hh_tens, hh_units};
    mm = {mm_tens, mm_units};
    ss = {ss_tens, ss_units};
end

endmodule