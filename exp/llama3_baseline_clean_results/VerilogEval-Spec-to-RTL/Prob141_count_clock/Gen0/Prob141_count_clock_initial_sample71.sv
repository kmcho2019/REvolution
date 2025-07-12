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
reg pm_reg;

assign hh = {4'b0, hours};
assign mm = {2'b0, minutes[5:4], minutes[3:0]};
assign ss = {2'b0, seconds[5:4], seconds[3:0]};
assign pm = pm_reg;

always @(posedge clk) begin
    if (reset) begin
        hours <= 1; // 12 in BCD
        minutes <= 0;
        seconds <= 0;
        pm_reg <= 0; // AM
    end else if (ena) begin
        if (seconds == 6'd59) begin
            seconds <= 0;
            if (minutes == 6'd59) begin
                minutes <= 0;
                if (hours == 4'd12) begin
                    hours <= 1; // 01 in BCD
                    pm_reg <= ~pm_reg; // toggle AM/PM
                end else if (hours == 4'd6) begin
                    hours <= 7; // 07 in BCD
                end else if (hours == 4'd0) begin
                    hours <= 10; // 10 in BCD
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

endmodule