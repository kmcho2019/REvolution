module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

// BCD digit registers for seconds (units and tens)
reg [3:0] ss_u, ss_t;
// BCD digit registers for minutes (units and tens)
reg [3:0] mm_u, mm_t;
// BCD digit registers for hours (units and tens)
reg [3:0] hh_u, hh_t;

// Next state signals (combinational)
reg [3:0] next_ss_u, next_ss_t;
reg [3:0] next_mm_u, next_mm_t;
reg [3:0] next_hh_u, next_hh_t;
reg       pm_next;

// Helper: Increment BCD digit with given max digit for units or tens
// For units digit max is 9 except hours units max varies when tens=1 (2 for 12 hours)
function [3:0] inc_bcd_digit(input [3:0] digit, input [3:0] max_digit);
    begin
        if(digit == max_digit)
            inc_bcd_digit = 4'd0;
        else
            inc_bcd_digit = digit + 4'd1;
    end
endfunction

// Detect if seconds rolled over
wire sec_rollover = (ss_t == 4'd5) && (ss_u == 4'd9) && ena;
// Detect if minutes rolled over
wire min_rollover = (mm_t == 4'd5) && (mm_u == 4'd9) && sec_rollover;

// Hour logic constraints:
// Hours count from 01 to 12, BCD tens can be 0 or 1.
// When tens=0, units count 1..9
// When tens=1, units count 0..2 (for 10,11,12)
// After 12 comes 01 again.
// On hour increment, detect if hour changes from 11 to 12 to toggle pm.

// Function to check if current hour is 11 (BCD)
function is_hour_11;
    input [3:0] t, u;
    begin
        is_hour_11 = (t == 4'd1) && (u == 4'd1);
    end
endfunction

// Function to check if current hour is 12 (BCD)
function is_hour_12;
    input [3:0] t, u;
    begin
        is_hour_12 = (t == 4'd1) && (u == 4'd2);
    end
endfunction

// Compute next seconds
always @(*) begin
    if (ena) begin
        if (ss_u == 4'd9) begin
            next_ss_u = 4'd0;
            if (ss_t == 4'd5)
                next_ss_t = 4'd0;
            else
                next_ss_t = ss_t + 4'd1;
        end else begin
            next_ss_u = ss_u + 4'd1;
            next_ss_t = ss_t;
        end
    end else begin
        next_ss_u = ss_u;
        next_ss_t = ss_t;
    end
end

// Compute next minutes
always @(*) begin
    if (sec_rollover) begin
        if (mm_u == 4'd9) begin
            next_mm_u = 4'd0;
            if (mm_t == 4'd5)
                next_mm_t = 4'd0;
            else
                next_mm_t = mm_t + 4'd1;
        end else begin
            next_mm_u = mm_u + 4'd1;
            next_mm_t = mm_t;
        end
    end else begin
        next_mm_u = mm_u;
        next_mm_t = mm_t;
    end
end

// Compute next hours and pm toggle
always @(*) begin
    pm_next = pm;
    if (min_rollover) begin
        // increment hours BCD
        if (is_hour_12(hh_t, hh_u)) begin
            // roll from 12 to 01
            next_hh_t = 4'd0;
            next_hh_u = 4'd1;
            pm_next = ~pm; // toggle pm on rollover 12->1
        end else if (hh_t == 4'd0) begin
            // tens=0, units 1..9
            if (hh_u == 4'd9) begin
                // next hour is 10
                next_hh_t = 4'd1;
                next_hh_u = 4'd0;
            end else begin
                next_hh_t = hh_t;
                next_hh_u = hh_u + 4'd1;
            end
        end else if (hh_t == 4'd1) begin
            // tens=1, units 0..2 for 10,11,12
            if (hh_u == 4'd2) begin
                // just handled above in is_hour_12 check, so we don't reach here
                // but just in case, roll to 01
                next_hh_t = 4'd0;
                next_hh_u = 4'd1;
                pm_next = ~pm;
            end else begin
                next_hh_t = hh_t;
                next_hh_u = hh_u + 4'd1;
            end
        end else begin
            // should not happen, keep current hour
            next_hh_t = hh_t;
            next_hh_u = hh_u;
        end
    end else begin
        // no hour increment
        next_hh_t = hh_t;
        next_hh_u = hh_u;
    end
end

// Sequential logic: update all registers on posedge clk with synchronous reset
always @(posedge clk) begin
    if (reset) begin
        // Initialize to 12:00:00 AM
        hh_t <= 4'd1;
        hh_u <= 4'd2;
        mm_t <= 4'd0;
        mm_u <= 4'd0;
        ss_t <= 4'd0;
        ss_u <= 4'd0;
        pm   <= 1'b0; // AM
    end else begin
        ss_t <= next_ss_t;
        ss_u <= next_ss_u;
        mm_t <= next_mm_t;
        mm_u <= next_mm_u;
        hh_t <= next_hh_t;
        hh_u <= next_hh_u;
        pm   <= pm_next;
    end
end

// Outputs: pack BCD digits into 8-bit outputs
always @(*) begin
    hh = {hh_t, hh_u};
    mm = {mm_t, mm_u};
    ss = {ss_t, ss_u};
end

endmodule