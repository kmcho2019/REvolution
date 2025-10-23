module TopModule(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

reg [7:0] hours, minutes, seconds;
reg pm_reg;

always @(posedge clk) begin
    if (reset) begin
        hours <= 1; // 01 in BCD
        minutes <= 0; // 00 in BCD
        seconds <= 0; // 00 in BCD
        pm_reg <= 0; // AM
    end else if (ena) begin
        if (seconds == 8'd59) begin
            seconds <= 0;
            if (minutes == 8'd59) begin
                minutes <= 0;
                if (hours == 8'd12) begin
                    hours <= 1; // 01 in BCD
                    pm_reg <= ~pm_reg; // toggle pm
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

assign pm = pm_reg;
assign hh = hours;
assign mm = minutes;
assign ss = seconds;

endmodule