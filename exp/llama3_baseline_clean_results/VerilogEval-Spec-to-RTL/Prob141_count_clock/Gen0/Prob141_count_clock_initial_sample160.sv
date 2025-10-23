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

assign pm = pm_reg;
assign hh = {hours[3], hours[2], hours[1], hours[0], 4'b0};
assign mm = {minutes[3], minutes[2], minutes[1], minutes[0], 4'b0};
assign ss = {seconds[3], seconds[2], seconds[1], seconds[0], 4'b0};

always @(posedge clk) begin
    if (reset) begin
        seconds <= 4'd0;
        minutes <= 4'd0;
        hours <= 4'd1;
        pm_reg <= 1'b0;
    end else if (ena) begin
        if (seconds == 4'd59) begin
            seconds <= 4'd0;
            if (minutes == 4'd59) begin
                minutes <= 4'd0;
                if (hours == (pm_reg ? 4'd12 : 4'd11)) begin
                    hours <= 4'd1;
                    pm_reg <= ~pm_reg;
                end else begin
                    hours <= hours + 1'b1;
                end
            end else begin
                minutes <= minutes + 1'b1;
            end
        end else begin
            seconds <= seconds + 1'b1;
        end
    end
end

endmodule