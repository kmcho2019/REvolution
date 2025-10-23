module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output wire [7:0] hh,
    output wire [7:0] mm,
    output wire [7:0] ss
);

// Internal binary counters
reg [5:0] seconds; // 0 - 59
reg [5:0] minutes; // 0 - 59
reg [3:0] hours;   // 1 - 12 (stored as 4-bit binary 1-12)

// Increment logic on ena
always @(posedge clk) begin
    if (reset) begin
        seconds <= 6'd0;
        minutes <= 6'd0;
        hours   <= 4'd12; // reset to 12
        pm      <= 1'b0;  // AM
    end else if (ena) begin
        // Increment seconds
        if (seconds == 6'd59) begin
            seconds <= 6'd0;
            // Increment minutes
            if (minutes == 6'd59) begin
                minutes <= 6'd0;
                // Increment hours 1-12
                if (hours == 4'd11) begin
                    hours <= 4'd12;
                    pm <= ~pm; // toggle PM on 11->12
                end else if (hours == 4'd12) begin
                    hours <= 4'd1;
                    // pm unchanged here
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

// Binary to BCD conversion function for two digits (0-59 or 1-12)
function [7:0] bin_to_bcd_2dig(input [5:0] val);
    integer tens;
    integer units;
    begin
        tens  = val / 10;
        units = val % 10;
        bin_to_bcd_2dig = {tens[3:0], units[3:0]};
    end
endfunction

// Special BCD convert for hours (1-12)
function [7:0] bin_to_bcd_hours(input [3:0] val);
    integer tens;
    integer units;
    begin
        tens  = val / 10;
        units = val % 10;
        bin_to_bcd_hours = {tens[3:0], units[3:0]};
    end
endfunction

assign ss = bin_to_bcd_2dig(seconds);
assign mm = bin_to_bcd_2dig(minutes);
assign hh = bin_to_bcd_hours(hours);

endmodule