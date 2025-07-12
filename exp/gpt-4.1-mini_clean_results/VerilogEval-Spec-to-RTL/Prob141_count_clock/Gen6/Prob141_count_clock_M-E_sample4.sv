module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

// Internal binary counters for seconds, minutes, and hours
reg [5:0] sec_bin;  // 0-59
reg [5:0] min_bin;  // 0-59
reg [3:0] hour_bin; // 1-12

// BCD conversion function: convert 6-bit or 4-bit binary to 2-digit BCD (8 bits)
function [7:0] bin_to_bcd;
    input [6:0] bin_in; // max input 7 bits for safety (up to 99)
    reg [3:0] tens;
    reg [3:0] units;
begin
    tens  = bin_in / 10;
    units = bin_in % 10;
    bin_to_bcd = {tens, units};
end
endfunction

// BCD conversion for hours: input 4-bit (1-12)
function [7:0] hour_bin_to_bcd;
    input [3:0] h;
    reg [3:0] tens;
    reg [3:0] units;
begin
    // hours only go from 1 to 12
    tens  = (h >= 10) ? 4'd1 : 4'd0;
    units = (h >= 10) ? (h - 10) : h;
    hour_bin_to_bcd = {tens, units};
end
endfunction

always @(posedge clk) begin
    if (reset) begin
        pm      <= 1'b0;    // AM
        sec_bin <= 6'd0;
        min_bin <= 6'd0;
        hour_bin<= 4'd12;   // 12 o'clock
    end else if (ena) begin
        // Increment seconds
        if (sec_bin == 6'd59) begin
            sec_bin <= 6'd0;
            // Increment minutes
            if (min_bin == 6'd59) begin
                min_bin <= 6'd0;
                // Increment hours (1 to 12)
                if (hour_bin == 4'd12) begin
                    hour_bin <= 4'd1;
                    pm <= ~pm; // toggle AM/PM at 12 -> 1 transition
                end else begin
                    hour_bin <= hour_bin + 4'd1;
                end
            end else begin
                min_bin <= min_bin + 6'd1;
            end
        end else begin
            sec_bin <= sec_bin + 6'd1;
        end
    end
end

// Combinational output assignments with BCD conversion
always @(*) begin
    hh = hour_bin_to_bcd(hour_bin);
    mm = bin_to_bcd(min_bin);
    ss = bin_to_bcd(sec_bin);
end

endmodule