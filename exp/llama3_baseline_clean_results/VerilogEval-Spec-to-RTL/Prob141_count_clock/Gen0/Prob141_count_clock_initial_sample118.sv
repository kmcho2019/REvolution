module TopModule(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

reg [7:0] hours;
reg [7:0] minutes;
reg [7:0] seconds;
reg pm_reg;

always @(posedge clk) begin
    if (reset) begin
        // Reset the counters to "12:00 AM"
        hours <= 8'h01; // 01 in BCD
        minutes <= 8'h00;
        seconds <= 8'h00;
        pm_reg <= 1'b0; // AM
    end else if (ena) begin
        // Increment the seconds counter
        if (seconds == 8'h60) begin
            // Reset the seconds counter and increment the minutes counter
            seconds <= 8'h00;
            if (minutes == 8'h60) begin
                // Reset the minutes counter and increment the hours counter
                minutes <= 8'h00;
                if (hours == 8'h12) begin
                    // 12 PM, reset to 1 PM
                    hours <= 8'h01;
                    pm_reg <= 1'b1; // PM
                end else if (hours == 8'h13) begin
                    // 1 AM, reset to 12 AM
                    hours <= 8'h12;
                    pm_reg <= 1'b0; // AM
                end else begin
                    // Increment the hours counter
                    if (pm_reg == 1'b0 && hours == 8'h12) begin
                        // 12 AM, set to 1 AM
                        hours <= 8'h01;
                    end else if (pm_reg == 1'b1 && hours == 8'h12) begin
                        // 12 PM, set to 1 PM
                        hours <= 8'h01;
                    end else begin
                        // Increment the hours counter
                        hours <= hours + 8'h01;
                    end
                end
            end else begin
                // Increment the minutes counter
                minutes <= minutes + 8'h01;
            end
        end else begin
            // Increment the seconds counter
            seconds <= seconds + 8'h01;
        end
    end
end

assign hh = hours;
assign mm = minutes;
assign ss = seconds;
assign pm = pm_reg;

endmodule