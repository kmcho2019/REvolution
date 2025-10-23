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
        hours <= 12; // 12 in BCD is 00010010
        minutes <= 0; // 00 in BCD is 00000000
        seconds <= 0; // 00 in BCD is 00000000
        pm_reg <= 0; // AM
    end else if (ena) begin
        // increment seconds
        if (seconds == 8'h59) begin // 59 in BCD is 01011001
            seconds <= 8'h00; // reset seconds to 00
            // increment minutes
            if (minutes == 8'h59) begin // 59 in BCD is 01011001
                minutes <= 8'h00; // reset minutes to 00
                // increment hours
                if (hours == 12 && pm_reg == 1) begin // 12 PM
                    hours <= 12; // 12 in BCD is 00010010
                    pm_reg <= 0; // AM
                end else if (hours == 12 && pm_reg == 0) begin // 12 AM
                    hours <= 1; // 01 in BCD is 00000001
                    pm_reg <= 1; // PM
                end else if (hours >= 1 && hours < 12) begin // 01-11
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

assign hh = hours;
assign mm = minutes;
assign ss = seconds;
assign pm = pm_reg;

endmodule