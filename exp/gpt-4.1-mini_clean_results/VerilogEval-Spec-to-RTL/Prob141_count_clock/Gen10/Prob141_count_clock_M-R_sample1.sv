module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

// Internal binary counters
reg [5:0] seconds_bin; // 0-59
reg [5:0] minutes_bin; // 0-59
reg [3:0] hours_bin;   // 1-12

// BCD conversion function for two digits (0-59)
function [7:0] bin2bcd60;
    input [5:0] bin_val; // up to 59
    reg [3:0] tens;
    reg [3:0] units;
    begin
        tens = bin_val / 10;
        units = bin_val % 10;
        bin2bcd60 = {tens, units};
    end
endfunction

// BCD conversion function for hours (1-12)
function [7:0] bin2bcd12;
    input [3:0] bin_val; // 1-12
    reg [3:0] tens;
    reg [3:0] units;
    begin
        tens = 4'd0;
        units = bin_val;
        if (bin_val >= 10) begin
            tens = 4'd1;
            units = bin_val - 4'd10;
        end
        bin2bcd12 = {tens, units};
    end
endfunction

always @(posedge clk) begin
    if (reset) begin
        seconds_bin <= 6'd0;
        minutes_bin <= 6'd0;
        hours_bin   <= 4'd12;
        pm          <= 1'b0;  // AM
    end else if (ena) begin
        // Increment seconds
        if (seconds_bin == 6'd59) begin
            seconds_bin <= 6'd0;
            // Increment minutes
            if (minutes_bin == 6'd59) begin
                minutes_bin <= 6'd0;
                // Increment hours
                if (hours_bin == 4'd11) begin
                    hours_bin <= 4'd12;
                    pm <= ~pm; // toggle pm at 11->12 transition
                end else if (hours_bin == 4'd12) begin
                    hours_bin <= 4'd1;
                    // pm unchanged
                end else begin
                    hours_bin <= hours_bin + 4'd1;
                end
            end else begin
                minutes_bin <= minutes_bin + 6'd1;
            end
        end else begin
            seconds_bin <= seconds_bin + 6'd1;
        end
    end
end

// Combinational BCD output conversions
always @(*) begin
    ss = bin2bcd60(seconds_bin);
    mm = bin2bcd60(minutes_bin);
    hh = bin2bcd12(hours_bin);
end

endmodule