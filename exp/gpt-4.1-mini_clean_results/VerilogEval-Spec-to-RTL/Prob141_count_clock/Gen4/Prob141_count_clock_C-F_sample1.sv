module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

// Separate BCD digits: units and tens for seconds, minutes, hours
reg [3:0] ss_units, ss_tens;
reg [3:0] mm_units, mm_tens;
reg [3:0] hh_units, hh_tens;

reg next_pm;
reg [3:0] next_ss_units, next_ss_tens;
reg [3:0] next_mm_units, next_mm_tens;
reg [3:0] next_hh_units, next_hh_tens;

// Helper function: increment BCD digit with given max rollover
function [3:0] bcd_inc_digit(input [3:0] val, input [3:0] max);
    begin
        if (val == max)
            bcd_inc_digit = 4'd0;
        else
            bcd_inc_digit = val + 4'd1;
    end
endfunction

// Check if BCD digit equals a value
function bcd_eq(input [3:0] val, input [3:0] cmp);
    begin
        bcd_eq = (val == cmp);
    end
endfunction

// Combinational next-state logic
always @* begin
    // Default no change
    next_pm       = pm;
    next_ss_units = ss_units;
    next_ss_tens  = ss_tens;
    next_mm_units = mm_units;
    next_mm_tens  = mm_tens;
    next_hh_units = hh_units;
    next_hh_tens  = hh_tens;

    if (ena) begin
        // Increment seconds units
        if (bcd_eq(ss_units,4'd9)) begin
            next_ss_units = 4'd0;
            // Increment seconds tens
            if (bcd_eq(ss_tens,4'd5)) begin
                next_ss_tens = 4'd0;
                // Increment minutes units
                if (bcd_eq(mm_units,4'd9)) begin
                    next_mm_units = 4'd0;
                    // Increment minutes tens
                    if (bcd_eq(mm_tens,4'd5)) begin
                        next_mm_tens = 4'd0;
                        // Increment hours with 12-hour BCD logic
                        // Check current hour value before increment
                        // Compose current hour decimal number for clarity:
                        // hours = hh_tens*10 + hh_units, valid range 1..12
                        // After 12, rollover to 1
                        // On going from 11 to 12, toggle pm
                        // On going from 12 to 1, no toggle

                        // Check if hour is 11
                        if ((hh_tens == 4'd1) && (hh_units == 4'd1)) begin
                            // from 11 to 12: increment hour, toggle pm
                            next_pm = ~pm;
                            next_hh_tens = 4'd1;
                            next_hh_units = 4'd2;
                        end else if ((hh_tens == 4'd1) && (hh_units == 4'd2)) begin
                            // from 12 to 1: rollover to 01
                            next_hh_tens = 4'd0;
                            next_hh_units = 4'd1;
                        end else begin
                            // normal hour increment:
                            if (hh_units == 4'd9) begin
                                // tens digit increments, units resets to 0
                                next_hh_units = 4'd0;
                                // tens digit increment but max 1 for 12-hour format
                                if (hh_tens == 4'd0)
                                    next_hh_tens = 4'd1;
                                else
                                    next_hh_tens = 4'd0; // rollover case not normally expected here, but safe
                            end else begin
                                // increment units digit normally
                                next_hh_units = hh_units + 4'd1;
                            end
                        end
                    end else begin
                        // Increment minutes tens digit normally
                        next_mm_tens = mm_tens + 4'd1;
                    end
                end else begin
                    // Increment minutes units normally
                    next_mm_units = mm_units + 4'd1;
                end
            end else begin
                // Increment seconds tens normally
                next_ss_tens = ss_tens + 4'd1;
            end
        end else begin
            // Increment seconds units normally
            next_ss_units = ss_units + 4'd1;
        end
    end
end

// Sequential state update with synchronous reset
always @(posedge clk) begin
    if (reset) begin
        pm       <= 1'b0;    // AM
        hh_tens  <= 4'd1;    // 12
        hh_units <= 4'd2;
        mm_tens  <= 4'd0;
        mm_units <= 4'd0;
        ss_tens  <= 4'd0;
        ss_units <= 4'd0;
    end else begin
        pm       <= next_pm;
        hh_tens  <= next_hh_tens;
        hh_units <= next_hh_units;
        mm_tens  <= next_mm_tens;
        mm_units <= next_mm_units;
        ss_tens  <= next_ss_tens;
        ss_units <= next_ss_units;
    end
end

// Combine digits into 8-bit BCD outputs
always @(*) begin
    hh = {hh_tens, hh_units};
    mm = {mm_tens, mm_units};
    ss = {ss_tens, ss_units};
end

endmodule