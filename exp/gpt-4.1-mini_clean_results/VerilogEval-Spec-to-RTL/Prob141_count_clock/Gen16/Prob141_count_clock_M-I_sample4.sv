module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

// BCD digits for seconds and minutes
reg [3:0] ss_units, ss_tens;
reg [3:0] mm_units, mm_tens;
// BCD digits for hours (01-12)
reg [3:0] hh_units, hh_tens;

// Helper function: Increment BCD digit with max limit, returns (new_val, did_rollover)
function automatic [4:0] bcd_increment(input [3:0] val, input [3:0] max);
    reg [4:0] result;
    begin
        if (val == max) begin
            result = {1'b1, 4'd0}; // rollover = 1, value=0
        end else begin
            result = {1'b0, val + 1'b1}; // no rollover, incremented val
        end
        bcd_increment = result;
    end
endfunction

// Function to increment hour BCD (01-12), returns (new_tens, new_units, rollover_to_1, pm_toggle)
function automatic [10:0] bcd_hour_increment(input [3:0] tens, input [3:0] units);
    reg [3:0] new_tens, new_units;
    reg rollover_to_1;
    reg pm_toggle;
    begin
        // Current hour in BCD: tens, units (01-12)
        if (tens == 4'd0) begin
            // Hours 01-09
            if (units == 4'd9) begin
                new_tens = 4'd1; // 10
                new_units = 4'd0;
                rollover_to_1 = 1'b0;
                pm_toggle = 1'b0;
            end else if (units == 4'd1) begin
                // Special case for 11 -> 12
                new_tens = 4'd1;
                new_units = 4'd2;
                rollover_to_1 = 1'b0;
                pm_toggle = 1'b0;
            end else if (units == 4'd2) begin
                // 12 -> 01, rollover hour and toggle pm
                new_tens = 4'd0;
                new_units = 4'd1;
                rollover_to_1 = 1'b1;
                pm_toggle = 1'b1;
            end else begin
                // Normal increment
                new_tens = tens;
                new_units = units + 1'b1;
                rollover_to_1 = 1'b0;
                pm_toggle = 1'b0;
            end
        end else begin
            // tens == 1: hours 10,11,12 only valid here, but handled above
            // For safety, but in proper use this block won't be reached for invalid numbers
            new_tens = tens;
            new_units = units;
            rollover_to_1 = 1'b0;
            pm_toggle = 1'b0;
        end
        bcd_hour_increment = {pm_toggle, rollover_to_1, new_tens, new_units};
    end
endfunction

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
    end else if (ena) begin
        // Increment seconds
        {ss_tens, ss_units} = {ss_tens, ss_units}; // default no change
        {mm_tens, mm_units} = {mm_tens, mm_units};
        {hh_tens, hh_units} = {hh_tens, hh_units};
        
        // Increment seconds units
        {ss_units, ss_tens} <= {ss_units, ss_tens}; // placeholder for synthesis
        // Use temporary regs to hold next values
        reg [4:0] next_ss_units;
        reg [4:0] next_ss_tens;
        next_ss_units = bcd_increment(ss_units, 4'd9);
        if (next_ss_units[4] == 1'b0) begin
            // No rollover in units
            ss_units <= next_ss_units[3:0];
        end else begin
            // Rollover units to 0, increment tens
            ss_units <= 4'd0;
            next_ss_tens = bcd_increment(ss_tens, 4'd5);
            if (next_ss_tens[4] == 1'b0) begin
                // No rollover tens
                ss_tens <= next_ss_tens[3:0];
            end else begin
                // Rollover tens to 0, increment minutes
                ss_tens <= 4'd0;
                // Increment minutes units
                reg [4:0] next_mm_units;
                reg [4:0] next_mm_tens;
                next_mm_units = bcd_increment(mm_units, 4'd9);
                if (next_mm_units[4] == 1'b0) begin
                    mm_units <= next_mm_units[3:0];
                end else begin
                    mm_units <= 4'd0;
                    next_mm_tens = bcd_increment(mm_tens, 4'd5);
                    if (next_mm_tens[4] == 1'b0) begin
                        mm_tens <= next_mm_tens[3:0];
                    end else begin
                        // minutes rolled over 59->00, increment hour
                        mm_tens <= 4'd0;

                        // Increment hours with BCD function
                        reg pm_toggle;
                        reg rollover_to_1;
                        reg [3:0] new_hh_tens, new_hh_units;
                        {pm_toggle, rollover_to_1, new_hh_tens, new_hh_units} = bcd_hour_increment(hh_tens, hh_units);
                        hh_tens <= new_hh_tens;
                        hh_units <= new_hh_units;
                        if (pm_toggle)
                            pm <= ~pm;
                    end
                end
            end
        end
    end
end

// Combinational output assignments
always @(*) begin
    hh = {hh_tens, hh_units};
    mm = {mm_tens, mm_units};
    ss = {ss_tens, ss_units};
end

endmodule