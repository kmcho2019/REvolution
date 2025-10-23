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

always @(posedge clk) begin
    if (reset) begin
        hours <= 4'd12; // 12 in BCD
        minutes <= 6'd0;
        seconds <= 6'd0;
        pm_reg <= 1'b0; // AM
    end else if (ena) begin
        if (seconds == 6'd59) begin
            seconds <= 6'd0;
            if (minutes == 6'd59) begin
                minutes <= 6'd0;
                if (hours == 4'd12) begin
                    hours <= 4'd1; // 1 in BCD
                    pm_reg <= ~pm_reg; // toggle AM/PM
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
assign hh = {4'd0, hours};
assign mm = {2'd0, minutes[5:4], minutes[3:0]};
assign ss = {2'd0, seconds[5:4], seconds[3:0]};

endmodule