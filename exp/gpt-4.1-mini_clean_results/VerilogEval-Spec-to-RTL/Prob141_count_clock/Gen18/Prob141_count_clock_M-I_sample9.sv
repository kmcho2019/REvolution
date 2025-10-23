module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

// BCD digits for seconds, minutes, and hours
reg [3:0] ss_units, ss_tens;
reg [3:0] mm_units, mm_tens;
reg [3:0] hh_units, hh_tens;

// Next-state registers for all counters
reg [3:0] next_ss_units, next_ss_tens;
reg [3:0] next_mm_units, next_mm_tens;
reg [3:0] next_hh_units, next_hh_tens;
reg       next_pm;

// Internal signals for rollover detection
wire sec_rollover, min_rollover, hour_rollover;

// Combined combinational logic for next state updates
always @* begin
    // Default hold current state
    next_ss_units = ss_units;
    next_ss_tens  = ss_tens;
    next_mm_units = mm_units;
    next_mm_tens  = mm_tens;
    next_hh_units = hh_units;
    next_hh_tens  = hh_tens;
    next_pm       = pm;

    if (ena) begin
        // Increment seconds BCD
        if (ss_units == 4'd9) begin
            next_ss_units = 4'd0;
            if (ss_tens == 4'd5) begin
                next_ss_tens = 4'd0;
                // Seconds rollover
                // Increment minutes BCD
                if (mm_units == 4'd9) begin
                    next_mm_units = 4'd0;
                    if (mm_tens == 4'd5) begin
                        next_mm_tens = 4'd0;
                        // Minutes rollover
                        // Increment hour BCD (01 to 12)
                        if ( (hh_tens == 4'd1 && hh_units == 4'd2) ) begin
                            // Hour rolls from 12 to 01
                            next_hh_tens = 4'd0;
                            next_hh_units = 4'd1;
                            next_pm = ~pm; // Toggle pm on rollover from 12 to 01
                        end else if (hh_units == 4'd9) begin
                            // Hour units rolls from 9 to 0, tens increment
                            next_hh_units = 4'd0;
                            next_hh_tens = hh_tens + 4'd1;
                        end else begin
                            // Normal hour units increment
                            next_hh_units = hh_units + 4'd1;
                        end
                    end else begin
                        // Increment hour units (tens fixed)
                        next_mm_tens = mm_tens + 4'd1;
                    end
                end else begin
                    // Increment minute units
                    next_mm_units = mm_units + 4'd1;
                end
            end else begin
                // Increment second tens digit only
                next_ss_tens = ss_tens + 4'd1;
            end
        end else begin
            // Increment second units digit only
            next_ss_units = ss_units + 4'd1;
        end
    end
end

// Sequential logic with synchronous reset and update only on changes to reduce toggling
always @(posedge clk) begin
    if (reset) begin
        ss_units <= 4'd0;
        ss_tens  <= 4'd0;
        mm_units <= 4'd0;
        mm_tens  <= 4'd0;
        hh_units <= 4'd2; // Initialize to 12:00:00 AM
        hh_tens  <= 4'd1;
        pm       <= 1'b0; // AM
    end else if (ena) begin
        ss_units <= next_ss_units;
        ss_tens  <= next_ss_tens;
        mm_units <= next_mm_units;
        mm_tens  <= next_mm_tens;
        hh_units <= next_hh_units;
        hh_tens  <= next_hh_tens;
        pm       <= next_pm;
    end
end

// Output combinationally from BCD digits
always @(*) begin
    hh = {hh_tens, hh_units};
    mm = {mm_tens, mm_units};
    ss = {ss_tens, ss_units};
end

endmodule