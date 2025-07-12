module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

// Separate BCD digits: units and tens for seconds, minutes
reg [3:0] ss_units, ss_tens;
reg [3:0] mm_units, mm_tens;

// Hours internally as binary from 1 to 12 (4 bits sufficient)
reg [3:0] hour_bin;

reg next_pm;
reg [3:0] next_ss_units, next_ss_tens;
reg [3:0] next_mm_units, next_mm_tens;
reg [3:0] next_hour_bin;

// Helper function to increment BCD digit with given max rollover
function [3:0] bcd_inc_digit(input [3:0] val, input [3:0] max);
    begin
        if (val == max)
            bcd_inc_digit = 4'd0;
        else
            bcd_inc_digit = val + 4'd1;
    end
endfunction

// BCD to decimal digit converter (for hours output)
function [7:0] bin_hour_to_bcd(input [3:0] bin_hour);
    reg [3:0] tens;
    reg [3:0] units;
    begin
        // Binary hour is 1..12
        // tens digit is 1 if hour >= 10 else 0
        if (bin_hour >= 4'd10) begin
            tens  = 4'd1;
            units = bin_hour - 4'd10;
        end else begin
            tens  = 4'd0;
            units = bin_hour;
        end
        bin_hour_to_bcd = {tens, units};
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
    next_hour_bin = hour_bin;

    if (ena) begin
        // Increment seconds units
        if (ss_units == 4'd9) begin
            next_ss_units = 4'd0;
            // Increment seconds tens
            if (ss_tens == 4'd5) begin
                next_ss_tens = 4'd0;
                // Increment minutes units
                if (mm_units == 4'd9) begin
                    next_mm_units = 4'd0;
                    // Increment minutes tens
                    if (mm_tens == 4'd5) begin
                        next_mm_tens = 4'd0;
                        // Increment hours binary 1..12 with PM toggle
                        if (hour_bin == 4'd11) begin
                            // Going from 11 to 12: toggle pm
                            next_pm = ~pm;
                            next_hour_bin = 4'd12;
                        end else if (hour_bin == 4'd12) begin
                            // Wrap from 12 to 1, no pm toggle
                            next_hour_bin = 4'd1;
                        end else begin
                            // Normal increment
                            next_hour_bin = hour_bin + 4'd1;
                        end
                    end else begin
                        next_mm_tens = mm_tens + 4'd1;
                    end
                end else begin
                    next_mm_units = mm_units + 4'd1;
                end
            end else begin
                next_ss_tens = ss_tens + 4'd1;
            end
        end else begin
            next_ss_units = ss_units + 4'd1;
        end
    end
end

// Sequential state update with synchronous reset
always @(posedge clk) begin
    if (reset) begin
        pm       <= 1'b0;    // AM
        hour_bin <= 4'd12;   // 12
        mm_tens  <= 4'd0;
        mm_units <= 4'd0;
        ss_tens  <= 4'd0;
        ss_units <= 4'd0;
    end else begin
        pm       <= next_pm;
        hour_bin <= next_hour_bin;
        mm_tens  <= next_mm_tens;
        mm_units <= next_mm_units;
        ss_tens  <= next_ss_tens;
        ss_units <= next_ss_units;
    end
end

// Convert binary hour to BCD output
always @(*) begin
    hh = bin_hour_to_bcd(hour_bin);
    mm = {mm_tens, mm_units};
    ss = {ss_tens, ss_units};
end

endmodule