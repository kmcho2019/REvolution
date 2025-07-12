module TopModule(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

reg [3:0] seconds;
reg [3:0] minutes;
reg [3:0] hours;
reg pm_reg;

always @(posedge clk) begin
    if (reset) begin
        // Reset all counters to their initial state
        seconds <= 4'b0000;
        minutes <= 4'b0000;
        hours <= 4'b0001; // 01 in BCD
        pm_reg <= 1'b0; // AM
    end else if (ena) begin
        // Increment seconds counter
        seconds <= seconds + 1'b1;
        // If seconds overflows, reset it and increment minutes
        if (seconds == 4'b1001) begin // 60 in decimal, but since we are counting from 00 to 59
            seconds <= 4'b0000;
            minutes <= minutes + 1'b1;
            // If minutes overflows, reset it and increment hours
            if (minutes == 4'b1001) begin // 60 in decimal
                minutes <= 4'b0000;
                hours <= hours + 1'b1;
                // Handle hours overflow with AM/PM logic
                if (hours == 4'b1101) begin // 13 in decimal, which should reset to 01
                    hours <= 4'b0001; // 01 in BCD
                end else if (hours == 4'b1100) begin // 12 in decimal
                    pm_reg <= ~pm_reg; // Flip AM/PM
                end
            end
        end
    end
end

// Continuous assignments to convert internal representations to output format
assign hh = {4'b0000, hours}; // hours are only 4 bits
assign mm = {4'b0000, minutes}; // minutes are only 4 bits
assign ss = {4'b0000, seconds}; // seconds are only 4 bits
assign pm = pm_reg;

endmodule