module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

    // BCD counters for seconds and minutes
    reg [3:0] ss_units, ss_tens;  // seconds units 0-9, tens 0-5
    reg [3:0] mm_units, mm_tens;  // minutes units 0-9, tens 0-5

    // Internal binary hour counter: 1 to 12
    reg [3:0] hour_bin;

    // Rollover detection signals (combinational)
    wire sec_rollover = (ss_tens == 4'd5) && (ss_units == 4'd9);
    wire min_rollover = (mm_tens == 4'd5) && (mm_units == 4'd9);

    // Next values for seconds and minutes BCD counters
    wire [3:0] ss_units_next;
    wire [3:0] ss_tens_next;
    wire [3:0] mm_units_next;
    wire [3:0] mm_tens_next;

    // Calculate next seconds
    assign ss_units_next = (ss_units == 4'd9) ? 4'd0 : ss_units + 4'd1;
    assign ss_tens_next  = (ss_units == 4'd9) ? ((ss_tens == 4'd5) ? 4'd0 : ss_tens + 4'd1) : ss_tens;

    // Calculate next minutes (only increment if seconds rollover)
    assign mm_units_next = (sec_rollover) ? ((mm_units == 4'd9) ? 4'd0 : mm_units + 4'd1) : mm_units;
    assign mm_tens_next  = (sec_rollover && (mm_units == 4'd9)) ? ((mm_tens == 4'd5) ? 4'd0 : mm_tens + 4'd1) : mm_tens;

    // Calculate next hour binary counter (only increment if minutes rollover)
    wire [3:0] hour_bin_next;
    wire       pm_toggle;
    assign pm_toggle = (hour_bin == 4'd11) && min_rollover;
    assign hour_bin_next = (min_rollover) ?
                            ((hour_bin == 4'd12) ? 4'd1 : hour_bin + 4'd1) :
                            hour_bin;

    // Function: Convert 1-12 binary hour to 2-digit BCD without subtraction
    // Uses simple conditional logic to avoid combinational subtraction:
    // 1..9 -> 0x1..9, 10..12 -> 0x10..12 as BCD tens=1, units=hour-10
    function [7:0] bin_to_bcd_hour;
        input [3:0] bin_hour;
        begin
            if (bin_hour < 4'd10)
                bin_to_bcd_hour = {4'd0, bin_hour};          // tens=0, units=bin_hour
            else if (bin_hour == 4'd10)
                bin_to_bcd_hour = {4'd1, 4'd0};
            else if (bin_hour == 4'd11)
                bin_to_bcd_hour = {4'd1, 4'd1};
            else // bin_hour == 12
                bin_to_bcd_hour = {4'd1, 4'd2};
        end
    endfunction

    // Registers for output values to reduce glitches and toggling
    reg [7:0] hh_reg, mm_reg, ss_reg;
    reg       pm_reg;

    always @(posedge clk) begin
        if (reset) begin
            // Synchronous reset to 12:00:00 AM
            ss_units <= 4'd0;
            ss_tens  <= 4'd0;
            mm_units <= 4'd0;
            mm_tens  <= 4'd0;
            hour_bin <= 4'd12;
            pm       <= 1'b0;
            // Initialize output registers
            hh_reg   <= 8'h12; // 12 in BCD: 0x12
            mm_reg   <= 8'd0;
            ss_reg   <= 8'd0;
            pm_reg   <= 1'b0;
        end else begin
            if (ena) begin
                // Update seconds counters
                ss_units <= ss_units_next;
                ss_tens  <= ss_tens_next;

                // Update minutes counters if seconds rollover
                if (sec_rollover) begin
                    mm_units <= mm_units_next;
                    mm_tens  <= mm_tens_next;
                end

                // Update hour counter and PM if minutes rollover
                if (min_rollover && sec_rollover) begin
                    hour_bin <= hour_bin_next;
                    if (pm_toggle)
                        pm <= ~pm;
                end
            end

            // Register outputs every clock cycle for glitch-free outputs
            hh_reg <= bin_to_bcd_hour(hour_bin);
            mm_reg <= {mm_tens, mm_units};
            ss_reg <= {ss_tens, ss_units};
            pm_reg <= pm;
        end
    end

    // Assign registered outputs
    always @(*) begin
        hh = hh_reg;
        mm = mm_reg;
        ss = ss_reg;
        pm = pm_reg;
    end

endmodule