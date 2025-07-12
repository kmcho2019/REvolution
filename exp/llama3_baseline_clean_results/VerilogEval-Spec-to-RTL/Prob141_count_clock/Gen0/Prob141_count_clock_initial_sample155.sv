module TopModule(
    input  clk,
    input  reset,
    input  ena,
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
        pm_reg <= 1'b0;
    end else if (ena) begin
        if (seconds == 8'h59) begin // 59 in BCD
            seconds <= 8'h00; // 00 in BCD
            if (minutes == 8'h59) begin // 59 in BCD
                minutes <= 8'h00; // 00 in BCD
                if (hours == 8'h12) begin // 12 in BCD
                    hours <= 8'h01; // 01 in BCD
                    pm_reg <= ~pm_reg;
                end else begin
                    hours <= hours + 8'h01; // increment hours
                    // handle BCD carry for hours
                    if (hours[3:0] == 8'h10) begin
                        hours[3:0] <= 8'h00; // 00 in BCD
                    end
                end
            end else begin
                minutes <= minutes + 8'h01; // increment minutes
                // handle BCD carry for minutes
                if (minutes[3:0] == 8'h10) begin
                    minutes[3:0] <= 8'h00; // 00 in BCD
                end
            end
        end else begin
            seconds <= seconds + 8'h01; // increment seconds
            // handle BCD carry for seconds
            if (seconds[3:0] == 8'h10) begin
                seconds[3:0] <= 8'h00; // 00 in BCD
            end
        end
    end
end

assign hh = hours;
assign mm = minutes;
assign ss = seconds;
assign pm = pm_reg;

endmodule