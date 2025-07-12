module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

// Internal binary counters for seconds (0-59), minutes (0-59), hours (1-12)
reg [5:0] seconds; // 0-59
reg [5:0] minutes; // 0-59
reg [3:0] hours;   // 1-12 (4 bits are enough for 12)

// Increment counters on ena pulse synchronously with reset
always @(posedge clk) begin
    if (reset) begin
        // Reset to 12:00:00 AM
        pm      <= 1'b0;
        seconds <= 6'd0;
        minutes <= 6'd0;
        hours   <= 4'd12;
    end else if (ena) begin
        if (seconds == 6'd59) begin
            seconds <= 6'd0;
            if (minutes == 6'd59) begin
                minutes <= 6'd0;
                // Hour increment with 12-hour wrap and PM toggle
                if (hours == 4'd11) begin
                    hours <= 4'd12;
                    pm <= ~pm; // Toggle PM when going from 11 to 12
                end else if (hours == 4'd12) begin
                    hours <= 4'd1;
                end else begin
                    hours <= hours + 4'd1;
                end
            end else begin
                minutes <= minutes + 6'd1;
            end
        end else begin
            seconds <= seconds + 6'd1;
        end
    end
end

// Function to convert 4-bit binary digit (0-9) to 4-bit BCD (same here since it's single digit)
function [3:0] bin_to_bcd_digit(input [3:0] bin);
    begin
        bin_to_bcd_digit = bin; // values <=9 guaranteed by usage
    end
endfunction

// Function to convert 6-bit number (0-59) to 8-bit BCD (two digits)
function [7:0] bin6_to_bcd8(input [5:0] bin6);
    reg [3:0] tens;
    reg [3:0] units;
    begin
        tens  = bin6 / 10;
        units = bin6 % 10;
        bin6_to_bcd8 = {tens, units};
    end
endfunction

// Convert hours (1-12) to BCD
// hours is 4-bit binary, so we split tens and units accordingly:
wire [3:0] hh_tens = (hours >= 10) ? 4'd1 : 4'd0;
wire [3:0] hh_units = (hours >= 10) ? (hours - 4'd10) : hours;

always @(*) begin
    hh = {hh_tens, hh_units};
    mm = bin6_to_bcd8(minutes);
    ss = bin6_to_bcd8(seconds);
end

endmodule