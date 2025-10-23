module TopModule(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

reg [3:0] hours;
reg [5:0] minutes;
reg [5:0] seconds;
reg pm_flag;

// BCD encoders
function [7:0] bcd_encoder;
    input [5:0] bin_value;
    reg [7:0] bcd_value;

    bcd_value = {4'b0000, bin_value[5:4], bin_value[3:0]};
    bcd_encoder = bcd_value;
endfunction

always @(posedge clk) begin
    if (reset) begin
        hours <= 12; // Initial hours (12)
        minutes <= 0; // Initial minutes (00)
        seconds <= 0; // Initial seconds (00)
        pm_flag <= 0; // Initial AM/PM flag (AM)
    end else if (ena) begin
        // Increment seconds
        if (seconds == 59) begin
            seconds <= 0;
            // Increment minutes
            if (minutes == 59) begin
                minutes <= 0;
                // Increment hours
                if (hours == 12) begin
                    hours <= 1;
                    pm_flag <= ~pm_flag; // Toggle AM/PM
                end else begin
                    hours <= hours + 1;
                end
            end else begin
                minutes <= minutes + 1;
            end
        end else begin
            seconds <= seconds + 1;
        end
    end
end

// Assign the output signals
assign hh = {4'b0000, hours};
assign mm = bcd_encoder(minutes);
assign ss = bcd_encoder(seconds);
assign pm = pm_flag;

endmodule