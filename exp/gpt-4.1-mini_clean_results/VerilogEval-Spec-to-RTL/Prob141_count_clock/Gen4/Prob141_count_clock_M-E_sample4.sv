module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg  [7:0] hh,
    output reg  [7:0] mm,
    output reg  [7:0] ss
);

// BCD digits:
// ss[7:4] = seconds tens (0-5)
// ss[3:0] = seconds units (0-9)
// mm[7:4] = minutes tens (0-5)
// mm[3:0] = minutes units (0-9)
// hh[7:4] = hours tens (0-1)
// hh[3:0] = hours units (0-9, but valid only 0-2 when tens=1)

// Internal signals for hour rollover detection to toggle pm
wire hour_rolled_over;

// BCD increment helper function for digits 0-9
function [3:0] bcd_inc_unit;
    input [3:0] digit;
    begin
        if (digit == 4'd9)
            bcd_inc_unit = 4'd0;
        else
            bcd_inc_unit = digit + 4'd1;
    end
endfunction

// Seconds increment logic
// Returns 1 if seconds rolled over from 59 to 00, else 0
function sec_increment(
    input [7:0] sec_bcd
);
    reg [3:0] tens;
    reg [3:0] units;
    begin
        tens = sec_bcd[7:4];
        units = sec_bcd[3:0];

        if (tens == 4'd5 && units == 4'd9)
            sec_increment = 1'b1;
        else
            sec_increment = 1'b0;
    end
endfunction

// Minutes increment logic same as seconds
function min_increment(
    input [7:0] min_bcd
);
    reg [3:0] tens;
    reg [3:0] units;
    begin
        tens = min_bcd[7:4];
        units = min_bcd[3:0];

        if (tens == 4'd5 && units == 4'd9)
            min_increment = 1'b1;
        else
            min_increment = 1'b0;
    end
endfunction

// Increment seconds BCD by one, with rollover to 00 after 59
function [7:0] sec_bcd_inc;
    input [7:0] sec_bcd;
    reg [3:0] tens;
    reg [3:0] units;
    begin
        tens = sec_bcd[7:4];
        units = sec_bcd[3:0];

        if (units == 4'd9) begin
            units = 4'd0;
            if (tens == 4'd5)
                tens = 4'd0;
            else
                tens = tens + 4'd1;
        end else begin
            units = units + 4'd1;
        end

        sec_bcd_inc = {tens, units};
    end
endfunction

// Increment minutes BCD by one, with rollover to 00 after 59
function [7:0] min_bcd_inc;
    input [7:0] min_bcd;
    reg [3:0] tens;
    reg [3:0] units;
    begin
        tens = min_bcd[7:4];
        units = min_bcd[3:0];

        if (units == 4'd9) begin
            units = 4'd0;
            if (tens == 4'd5)
                tens = 4'd0;
            else
                tens = tens + 4'd1;
        end else begin
            units = units + 4'd1;
        end

        min_bcd_inc = {tens, units};
    end
endfunction

// Increment hour BCD by one following 12-hour clock rules with pm toggle signal
// Returns incremented hour and rollover flag (rollover means hour went from 11 to 12)
function [11:0] hour_bcd_inc; // {rollover_flag, new_hh[7:0]}
    input [7:0] hour_bcd;
    reg [3:0] tens;
    reg [3:0] units;
    reg rollover;
    reg [3:0] new_tens;
    reg [3:0] new_units;
    begin
        tens = hour_bcd[7:4];
        units = hour_bcd[3:0];

        // Hour can be 12, 01..09, 10, 11
        // Increment follows:
        // if hour = 12 -> 01 (rollover)
        // if hour = 11 -> 12 (rollover)
        // else just add 1

        if (tens == 4'd1 && units == 4'd2) begin // 12 -> 01 rollover
            new_tens = 4'd0;
            new_units = 4'd1;
            rollover = 1'b1;
        end else if (tens == 4'd1 && units == 4'd1) begin // 11 -> 12 rollover
            new_tens = 4'd1;
            new_units = 4'd2;
            rollover = 1'b1;
        end else if (tens == 4'd0 && units == 4'd9) begin // 09 -> 10 no rollover
            new_tens = 4'd1;
            new_units = 4'd0;
            rollover = 1'b0;
        end else begin
            // Normal increment
            if (units == 4'd9) begin
                new_units = 4'd0;
                new_tens = tens + 4'd1;
            end else begin
                new_units = units + 4'd1;
                new_tens = tens;
            end
            rollover = 1'b0;
        end

        hour_bcd_inc = {rollover, new_tens, new_units};
    end
endfunction

// Sequential logic
always @(posedge clk) begin
    if (reset) begin
        // Reset to 12:00:00 AM
        ss <= 8'h00;    // 00 seconds
        mm <= 8'h00;    // 00 minutes
        hh <= 8'h12;    // 12 hours
        pm <= 1'b0;     // AM
    end else if (ena) begin
        // Increment seconds
        if (ss == 8'h59) begin
            ss <= 8'h00;
            // Increment minutes
            if (mm == 8'h59) begin
                mm <= 8'h00;
                // Increment hours with rollover detection
                reg rollover_flag;
                reg [7:0] new_hour;
                {rollover_flag, new_hour} = hour_bcd_inc(hh);
                hh <= new_hour;
                if (rollover_flag)
                    pm <= ~pm; // Toggle pm on hour rollover
            end else begin
                mm <= min_bcd_inc(mm);
            end
        end else begin
            ss <= sec_bcd_inc(ss);
        end
    end
end

endmodule