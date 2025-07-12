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
        // Reset all counters and pm signal
        seconds <= 0;
        minutes <= 0;
        hours <= 1; // 12 AM
        pm_reg <= 0; // AM
    end else if (ena) begin
        // Increment counters
        if (seconds == 9'd59) begin
            seconds <= 0;
            if (minutes == 9'd59) begin
                minutes <= 0;
                if (hours == 9'd12) begin
                    hours <= 1; // Wrap around to 1 AM
                    pm_reg <= 0; // AM
                end else if (hours == 9'd11) begin
                    hours <= 12;
                    pm_reg <= 1; // PM
                end else if (hours == 9'd12) begin
                    hours <= 1; // Wrap around to 1 AM
                    pm_reg <= 0; // AM
                end else begin
                    hours <= hours + 1;
                    if (hours > 9'd5 && hours < 9'd13) begin
                        pm_reg <= 1; // PM
                    end else begin
                        pm_reg <= 0; // AM
                    end
                end
            end else begin
                minutes <= minutes + 1;
            end
        end else begin
            seconds <= seconds + 1;
        end
    end
end

assign hh = {hours[3], hours[3:0]};
assign mm = {minutes[3], minutes[3:0]};
assign ss = {seconds[3], seconds[3:0]};
assign pm = pm_reg;

endmodule