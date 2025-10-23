module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

    // Internal BCD digits for seconds and minutes
    reg [3:0] ss_units, ss_tens;
    reg [3:0] mm_units, mm_tens;

    // Hour internal binary counter (1 to 12)
    reg [3:0] hour_bin; 

    // Next-state combinational signals for seconds
    wire ss_units_rollover = (ss_units == 4'd9);
    wire ss_tens_rollover  = (ss_tens == 4'd5);

    wire [3:0] next_ss_units = ena ? (ss_units_rollover ? 4'd0 : ss_units + 4'd1) : ss_units;
    wire [3:0] next_ss_tens  = ena ? (ss_units_rollover ? (ss_tens_rollover ? 4'd0 : ss_tens + 4'd1) : ss_tens) : ss_tens;

    // Minutes increment enable if seconds roll over from 59 to 00
    wire min_inc = ena && ss_units_rollover && ss_tens_rollover;

    wire mm_units_rollover = (mm_units == 4'd9);
    wire mm_tens_rollover  = (mm_tens == 4'd5);

    wire [3:0] next_mm_units = min_inc ? (mm_units_rollover ? 4'd0 : mm_units + 4'd1) : mm_units;
    wire [3:0] next_mm_tens  = min_inc ? (mm_units_rollover ? (mm_tens_rollover ? 4'd0 : mm_tens + 4'd1) : mm_tens) : mm_tens;

    // Hour increment enable if minutes roll over from 59 to 00
    wire hour_inc = min_inc && mm_units_rollover && mm_tens_rollover;

    // Detect hour rollover from 11 to 12 for pm toggle
    wire hour_roll_11_to_12 = (hour_bin == 4'd11) && hour_inc;

    wire [3:0] next_hour_bin = hour_inc ? ((hour_bin == 4'd12) ? 4'd1 : hour_bin + 4'd1) : hour_bin;

    // Binary to BCD function for hour (1..12)
    function [7:0] bin_to_bcd_hour(input [3:0] bin_hour);
        reg [7:0] val;
        begin
            if (bin_hour <= 4'd9) begin
                val = {4'd0, bin_hour};
            end else begin
                val = {4'd1, bin_hour - 4'd10};
            end
            bin_to_bcd_hour = val;
        end
    endfunction

    // Sequential logic: synchronous reset and state update
    always @(posedge clk) begin
        if (reset) begin
            pm       <= 1'b0;      // AM
            hour_bin <= 4'd12;     // 12:00 AM start
            mm_tens  <= 4'd0;
            mm_units <= 4'd0;
            ss_tens  <= 4'd0;
            ss_units <= 4'd0;
        end else begin
            // Update counters only on ena; reset handled above
            ss_units <= next_ss_units;
            ss_tens  <= next_ss_tens;
            mm_units <= next_mm_units;
            mm_tens  <= next_mm_tens;
            hour_bin <= next_hour_bin;
            // Toggle pm on hour rollover from 11 to 12
            if (hour_roll_11_to_12)
                pm <= ~pm;
        end
    end

    // Outputs combinationally assigned from registers
    always @* begin
        hh = bin_to_bcd_hour(hour_bin);
        mm = {mm_tens, mm_units};
        ss = {ss_tens, ss_units};
    end

endmodule