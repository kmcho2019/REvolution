module TopModule(
    input  clk,
    input  reset,
    input  ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

reg [3:0] seconds;
reg [5:0] minutes;
reg [3:0] hours;
reg pm_reg;

assign hh = {4'b0000, hours};
assign mm = {2'b00, minutes[5:4], minutes[3:0]};
assign ss = {2'b00, minutes[5:4], minutes[3:0]};
assign pm = pm_reg;

always @(posedge clk) begin
    if (reset) begin
        seconds <= 0;
        minutes <= 0;
        hours <= 1;
        pm_reg <= 0;
    end else if (ena) begin
        if (seconds == 9'd59) begin
            seconds <= 0;
            if (minutes == 6'd59) begin
                minutes <= 0;
                if (hours == 4'd12) begin
                    hours <= 1;
                    pm_reg <= ~pm_reg;
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