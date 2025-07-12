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

assign pm = pm_reg;
assign hh = (hours < 10) ? {4'b0001, hours} : {4'b0001, hours[3:0] + 4'd10};
assign mm = (minutes < 10) ? {4'b0000, minutes} : {4'b0000, minutes[5:4], minutes[3:0] + 4'd10};
assign ss = (seconds < 10) ? {4'b0000, seconds} : {4'b0000, seconds[5:4], seconds[3:0] + 4'd10};

always @(posedge clk) begin
    if (reset) begin
        hours <= 4'd12;
        minutes <= 6'd0;
        seconds <= 6'd0;
        pm_reg <= 1'b0;
    end else if (ena) begin
        if (seconds == 6'd59) begin
            seconds <= 6'd0;
            if (minutes == 6'd59) begin
                minutes <= 6'd0;
                if (hours == 4'd12) begin
                    hours <= 4'd1;
                    pm_reg <= ~pm_reg;
                end else if (hours == 4'd12 + 4'd12 - 1) begin
                    hours <= 4'd1;
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