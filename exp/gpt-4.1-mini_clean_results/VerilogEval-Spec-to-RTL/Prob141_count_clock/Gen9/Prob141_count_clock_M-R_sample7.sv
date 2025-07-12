module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

// Binary counters for seconds and minutes
reg [5:0] seconds;  // 0-59
reg [5:0] minutes;  // 0-59
reg [3:0] hour_bin; // 1-12 in binary

// Helper function: convert 0-59 binary to BCD (two digits)
function [7:0] bin6_to_bcd8(input [5:0] val);
    reg [3:0] tens, units;
    begin
        tens  = val / 10;
        units = val % 10;
        bin6_to_bcd8 = {tens, units};
    end
endfunction

// Helper function: convert 1-12 binary hour to BCD (two digits)
function [7:0] hour_bin_to_bcd(input [3:0] val);
    reg [3:0] tens, units;
    begin
        if (val <= 9) begin
            tens  = 4'd0;
            units = val;
        end else begin
            tens  = 4'd1;
            units = val - 4'd10;
        end
        hour_bin_to_bcd = {tens, units};
    end
endfunction

always @(posedge clk) begin
    if (reset) begin
        seconds <= 6'd0;
        minutes <= 6'd0;
        hour_bin <= 4'd12; // 12 o'clock
        pm <= 1'b0;        // AM
    end else if (ena) begin
        // Seconds increment and rollover
        if (seconds == 6'd59) begin
            seconds <= 6'd0;
            // Minutes increment and rollover
            if (minutes == 6'd59) begin
                minutes <= 6'd0;
                // Hours increment with 12-hour wrap and PM toggle
                if (hour_bin == 4'd12) begin
                    hour_bin <= 4'd1;
                end else begin
                    hour_bin <= hour_bin + 4'd1;
                end
                // Toggle pm when hour rolls over from 11 to 12
                if (hour_bin == 4'd11)
                    pm <= ~pm;
            end else begin
                minutes <= minutes + 6'd1;
            end
        end else begin
            seconds <= seconds + 6'd1;
        end
    end
end

// Outputs directly assigned combinationally from counters
always @(*) begin
    ss = bin6_to_bcd8(seconds);
    mm = bin6_to_bcd8(minutes);
    hh = hour_bin_to_bcd(hour_bin);
end

endmodule