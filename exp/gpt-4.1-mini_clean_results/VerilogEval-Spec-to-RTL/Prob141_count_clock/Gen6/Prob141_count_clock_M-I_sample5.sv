module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

// Internal counters
reg [5:0] seconds; // 0-59
reg [5:0] minutes; // 0-59
reg [3:0] hours;   // 1-12 (binary)

// Increment logic
wire seconds_rollover = (seconds == 6'd59);
wire minutes_rollover = (minutes == 6'd59);
wire hours_rollover = (hours == 4'd12);

// On reset: 12:00:00 AM (hours=12, pm=0)
always @(posedge clk) begin
    if (reset) begin
        seconds <= 6'd0;
        minutes <= 6'd0;
        hours   <= 4'd12;
        pm      <= 1'b0; // AM
    end else if (ena) begin
        // Increment seconds
        if (seconds_rollover) begin
            seconds <= 6'd0;
            // Increment minutes
            if (minutes_rollover) begin
                minutes <= 6'd0;
                // Increment hours
                if (hours_rollover) begin
                    hours <= 4'd1;
                    pm <= ~pm; // Toggle PM on rollover from 12 to 1
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

// Function to convert binary to BCD (two digits) for 0-59 or 1-12 range
function [7:0] bin_to_bcd_2dig(input [5:0] bin_val);
    integer tens;
    integer units;
begin
    tens = bin_val / 10;
    units = bin_val % 10;
    bin_to_bcd_2dig = {4'd0 + tens[3:0], 4'd0 + units[3:0]};
end
endfunction

// For hours (1-12), convert binary to BCD 2-digit output
function [7:0] hour_bin_to_bcd(input [3:0] bin_val);
    integer tens;
    integer units;
begin
    tens = bin_val / 10;
    units = bin_val % 10;
    hour_bin_to_bcd = {tens[3:0], units[3:0]};
end
endfunction

// Combinational output BCD conversion
always @(*) begin
    hh = hour_bin_to_bcd(hours);
    mm = bin_to_bcd_2dig(minutes);
    ss = bin_to_bcd_2dig(seconds);
end

endmodule