module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output wire [7:0] hh,
    output wire [7:0] mm,
    output wire [7:0] ss
);

// Internal binary counters for seconds (0-59), minutes (0-59), hours (1-12)
reg [5:0] seconds; // 0-59
reg [5:0] minutes; // 0-59
reg [3:0] hours;   // 1-12 (4 bits to cover 0-12, will avoid 0)

// Internal signal to detect hour rollover from 11 to 12
wire hour_rollover;
wire increment_pm;

// Increment logic synchronized with clk and ena
always @(posedge clk) begin
    if (reset) begin
        seconds <= 6'd0;
        minutes <= 6'd0;
        hours   <= 4'd12; // 12
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
                    pm <= ~pm; // toggle pm on 11->12 transition
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

// Function: Convert 6-bit binary 0-59 to two BCD digits (tens and units)
function [7:0] bin_to_bcd60;
    input [5:0] bin_val;
    reg [3:0] tens;
    reg [3:0] units;
begin
    tens = bin_val / 10;
    units = bin_val % 10;
    bin_to_bcd60 = {tens, units};
end
endfunction

// Function: Convert hours (1-12) binary to two BCD digits
function [7:0] bin_to_bcd12;
    input [3:0] bin_val;
    reg [3:0] tens;
    reg [3:0] units;
begin
    if (bin_val == 4'd12) begin
        tens = 4'd1;
        units = 4'd2;
    end else if (bin_val == 4'd10) begin
        tens = 4'd1;
        units = 4'd0;
    end else if (bin_val == 4'd11) begin
        tens = 4'd1;
        units = 4'd1;
    end else begin
        // 1-9
        tens = 4'd0;
        units = bin_val[3:0];
    end
    bin_to_bcd12 = {tens, units};
end
endfunction

// Convert internal counters to BCD outputs combinationally
assign ss = bin_to_bcd60(seconds);
assign mm = bin_to_bcd60(minutes);
assign hh = bin_to_bcd12(hours);

endmodule