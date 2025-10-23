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
reg [5:0] seconds; // 0-59
reg [5:0] minutes; // 0-59
reg [3:0] hours;   // 1-12, stored as binary (1 to 12)

// Function: Convert 0-59 binary to BCD (two digits)
function [7:0] bin_to_bcd_0_59;
    input [5:0] bin;
    reg [3:0] tens;
    reg [3:0] units;
begin
    tens  = bin / 10;
    units = bin % 10;
    bin_to_bcd_0_59 = {tens, units};
end
endfunction

// Function: Convert hours (1-12) binary to BCD
function [7:0] bin_to_bcd_1_12;
    input [3:0] bin;
    reg [3:0] tens;
    reg [3:0] units;
begin
    tens  = (bin == 12) ? 4'd1 : 4'd0;   // only 12 has tens digit 1
    units = (bin == 12) ? 4'd2 : bin;
    bin_to_bcd_1_12 = {tens, units};
end
endfunction

always @(posedge clk) begin
    if (reset) begin
        // Reset to 12:00:00 AM
        seconds <= 6'd0;
        minutes <= 6'd0;
        hours   <= 4'd12;
        pm      <= 1'b0;
    end else if (ena) begin
        // Increment seconds
        if (seconds == 6'd59) begin
            seconds <= 6'd0;
            // Increment minutes
            if (minutes == 6'd59) begin
                minutes <= 6'd0;
                // Increment hours 1 to 12
                if (hours == 4'd11) begin
                    // Going from 11 to 12 toggles pm
                    hours <= 4'd12;
                    pm <= ~pm;
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

// Combinational outputs as BCD
assign ss = bin_to_bcd_0_59(seconds);
assign mm = bin_to_bcd_0_59(minutes);
assign hh = bin_to_bcd_1_12(hours);

endmodule