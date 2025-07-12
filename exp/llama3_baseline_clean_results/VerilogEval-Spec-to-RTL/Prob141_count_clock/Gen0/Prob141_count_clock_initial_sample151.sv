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
        hours <= 8'b0001_0010; // 12 in BCD
        minutes <= 8'b0000_0000; // 00 in BCD
        seconds <= 8'b0000_0000; // 00 in BCD
        pm_reg <= 1'b0; // AM
    end else if (ena) begin
        if (seconds == 8'b0000_0101) begin // 59 in BCD
            seconds <= 8'b0000_0000; // reset seconds to 00
            if (minutes == 8'b0000_1001) begin // 59 in BCD
                minutes <= 8'b0000_0000; // reset minutes to 00
                if (hours == 8'b0001_0010) begin // 12 in BCD
                    hours <= 8'b0000_0001; // 01 in BCD
                    pm_reg <= ~pm_reg; // toggle AM/PM
                end else if (hours == 8'b0001_0000) begin // 12 in BCD, but it's PM
                    hours <= 8'b0000_0001; // 01 in BCD
                end else begin
                    hours <= hours + 1; // increment hours
                end
            end else begin
                minutes <= minutes + 1; // increment minutes
            end
        end else begin
            seconds <= seconds + 1; // increment seconds
        end
    end
end

assign hh = hours;
assign mm = minutes;
assign ss = seconds;
assign pm = pm_reg;

endmodule