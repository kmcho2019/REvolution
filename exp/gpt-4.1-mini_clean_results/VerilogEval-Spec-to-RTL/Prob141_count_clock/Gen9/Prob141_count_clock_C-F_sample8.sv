module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

// Separate BCD digits for seconds and minutes (each 4-bit)
reg [3:0] ss_units, ss_tens;
reg [3:0] mm_units, mm_tens;

// Hour internal binary counter (1..12)
reg [3:0] hour_bin;

// Next-state signals for seconds and minutes BCD digits
reg [3:0] next_ss_units, next_ss_tens;
reg [3:0] next_mm_units, next_mm_tens;

// Wires for rollover detection
wire sec_rollover;
wire min_rollover;

// Function: binary hour (1..12) to BCD 8-bit
function [7:0] bin_to_bcd_hour(input [3:0] bin_hour);
    begin
        if (bin_hour <= 4'd9)
            bin_to_bcd_hour = {4'd0, bin_hour};
        else
            bin_to_bcd_hour = {4'd1, bin_hour - 4'd10};
    end
endfunction

// Combinational next-state logic for seconds BCD digits when ena asserted
always @* begin
    // Default to hold current values
    next_ss_units = ss_units;
    next_ss_tens  = ss_tens;

    if (ena) begin
        if (ss_units == 4'd9) begin
            next_ss_units = 4'd0;
            if (ss_tens == 4'd5)
                next_ss_tens = 4'd0;
            else
                next_ss_tens = ss_tens + 4'd1;
        end else begin
            next_ss_units = ss_units + 4'd1;
        end
    end
end

assign sec_rollover = ena && (ss_tens == 4'd5) && (ss_units == 4'd9);

// Combinational next-state logic for minutes BCD digits on second rollover
always @* begin
    // Default hold current
    next_mm_units = mm_units;
    next_mm_tens  = mm_tens;

    if (sec_rollover) begin
        if (mm_units == 4'd9) begin
            next_mm_units = 4'd0;
            if (mm_tens == 4'd5)
                next_mm_tens = 4'd0;
            else
                next_mm_tens = mm_tens + 4'd1;
        end else begin
            next_mm_units = mm_units + 4'd1;
        end
    end
end

assign min_rollover = sec_rollover && (mm_tens == 4'd5) && (mm_units == 4'd9);

// Sequential logic updates with synchronous reset and enable gating
always @(posedge clk) begin
    if (reset) begin
        // Reset all counters and pm to 12:00 AM
        ss_units <= 4'd0;
        ss_tens  <= 4'd0;
        mm_units <= 4'd0;
        mm_tens  <= 4'd0;
        hour_bin <= 4'd12; // hour = 12
        pm       <= 1'b0;  // AM
    end else begin
        // Update seconds digits if ena
        ss_units <= next_ss_units;
        ss_tens  <= next_ss_tens;

        // Update minutes digits on second rollover
        mm_units <= next_mm_units;
        mm_tens  <= next_mm_tens;

        // Update hour and pm only on minute rollover
        if (min_rollover) begin
            if (hour_bin == 4'd12)
                hour_bin <= 4'd1;
            else
                hour_bin <= hour_bin + 4'd1;

            // Toggle pm only when hour rolls from 11 to 12
            if (hour_bin == 4'd11)
                pm <= ~pm;
        end
    end
end

// Output assignments combinationally
always @(*) begin
    hh = bin_to_bcd_hour(hour_bin);
    mm = {mm_tens, mm_units};
    ss = {ss_tens, ss_units};
end

endmodule