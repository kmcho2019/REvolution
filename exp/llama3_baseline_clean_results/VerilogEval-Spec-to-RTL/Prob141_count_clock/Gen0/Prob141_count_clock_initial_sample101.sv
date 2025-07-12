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
        hours <= 8'h01; // 01 in BCD
        minutes <= 8'h00; // 00 in BCD
        seconds <= 8'h00; // 00 in BCD
        pm_reg <= 1'b0; // AM
    end else if (ena) begin
        // Increment seconds
        if (seconds == 8'h59) begin
            seconds <= 8'h00; // 00 in BCD
            // Increment minutes
            if (minutes == 8'h59) begin
                minutes <= 8'h00; // 00 in BCD
                // Increment hours
                if (hours == 8'h12) begin // 12 in BCD
                    hours <= 8'h01; // 01 in BCD
                    pm_reg <= 1'b0; // AM
                end else if (hours == 8'h12 + 8'h12 - 1) begin // 11 in BCD (PM)
                    hours <= 8'h12; // 12 in BCD
                    pm_reg <= 1'b0; // AM
                end else begin
                    hours <= hours + 1;
                    if (hours >= 8'h12 && hours < 8'h12 + 8'h12) begin
                        pm_reg <= 1'b1; // PM
                    end else begin
                        pm_reg <= 1'b0; // AM
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

assign hh = hours;
assign mm = minutes;
assign ss = seconds;
assign pm = pm_reg;

endmodule