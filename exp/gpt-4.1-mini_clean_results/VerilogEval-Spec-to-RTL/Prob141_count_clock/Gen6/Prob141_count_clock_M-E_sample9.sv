module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

// Internal binary counters for seconds, minutes, hours
reg [5:0] seconds; // 0-59
reg [5:0] minutes; // 0-59
reg [3:0] hours;   // 1-12

// Intermediate signals for next state calculations
wire seconds_wrap = (seconds == 6'd59);
wire minutes_wrap = (minutes == 6'd59);
wire hour_is_11   = (hours == 4'd11);
wire hour_is_12   = (hours == 4'd12);

always @(posedge clk) begin
    if (reset) begin
        // Reset to 12:00:00 AM
        pm      <= 1'b0;
        hours   <= 4'd12;
        minutes <= 6'd0;
        seconds <= 6'd0;
    end else if (ena) begin
        // Increment seconds
        if (seconds_wrap) begin
            seconds <= 6'd0;
            // Increment minutes
            if (minutes_wrap) begin
                minutes <= 6'd0;
                // Increment hours
                if (hour_is_12) begin
                    hours <= 4'd1;
                end else begin
                    // Check if hour increments from 11 to 12 to toggle pm
                    if (hour_is_11)
                        pm <= ~pm;
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

// Function to convert binary 0-59 to BCD (8 bits: tens and units)
function [7:0] bin_to_bcd_60;
    input [5:0] bin_val; // max 59
    reg [3:0] tens;
    reg [3:0] units;
begin
    tens = bin_val / 10;
    units = bin_val % 10;
    bin_to_bcd_60 = {tens, units};
end
endfunction

// Function to convert binary hours (1-12) to BCD (8 bits)
function [7:0] bin_to_bcd_hour;
    input [3:0] bin_val; // 1-12
    reg [3:0] tens;
    reg [3:0] units;
begin
    if (bin_val == 4'd12) begin
        tens = 4'd1;
        units = 4'd2;
    end else if (bin_val >= 4'd10) begin
        tens = 4'd1;
        units = bin_val - 4'd10;
    end else begin
        tens = 4'd0;
        units = bin_val;
    end
    bin_to_bcd_hour = {tens, units};
end
endfunction

// Combinational output assignments
always @(*) begin
    hh = bin_to_bcd_hour(hours);
    mm = bin_to_bcd_60(minutes);
    ss = bin_to_bcd_60(seconds);
end

endmodule