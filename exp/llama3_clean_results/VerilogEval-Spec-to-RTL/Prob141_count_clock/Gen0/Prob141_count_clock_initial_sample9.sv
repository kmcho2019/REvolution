module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

reg [7:0] seconds;
reg [7:0] minutes;
reg [7:0] hours;
reg pm_reg;

always @(posedge clk) begin
    if (reset) begin
        // Reset the clock to "12:00 AM"
        seconds <= 8'b00000000;
        minutes <= 8'b00000000;
        hours <= 8'b00010010; // 12 in BCD
        pm_reg <= 1'b0; // AM
    end else if (ena) begin
        // Increment the seconds counter
        if (seconds == 8'b01011001) begin // 59 in BCD
            seconds <= 8'b00000000; // Reset to 00
            // Increment the minutes counter
            if (minutes == 8'b01011001) begin // 59 in BCD
                minutes <= 8'b00000000; // Reset to 00
                // Increment the hours counter
                if (hours == 8'b00010010 || hours == 8'b00010100) begin // 12 AM or 12 PM in BCD
                    hours <= (pm_reg)? 8'b00010001 : 8'b00010010; // 01 AM or 12 PM in BCD
                    pm_reg <= ~pm_reg;
                end else if (hours == 8'b00010111) begin // 11 in BCD
                    hours <= 8'b00010010; // 12 in BCD
                    pm_reg <= 1'b1; // PM
                end else if (hours == 8'b00001000) begin // 01 in BCD
                    hours <= 8'b00010001; // 02 in BCD
                end else begin
                    // Increment the hours counter
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

assign pm = pm_reg;
assign hh = hours;
assign mm = minutes;
assign ss = seconds;

endmodule