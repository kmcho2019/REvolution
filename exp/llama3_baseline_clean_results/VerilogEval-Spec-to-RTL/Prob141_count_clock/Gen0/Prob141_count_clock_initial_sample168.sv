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
reg [5:0] minutes;
reg [3:0] hours;
reg pm_reg;

always @(posedge clk) begin
    if (reset) begin
        seconds <= 4'b0000;
        minutes <= 6'b000000;
        hours <= 4'b0001;
        pm_reg <= 1'b0;
    end else if (ena) begin
        if (seconds == 4'b1011) begin // 59
            seconds <= 4'b0000;
            if (minutes == 6'b100011) begin // 59
                minutes <= 6'b000000;
                if (hours == 4'b1100) begin // 12
                    hours <= 4'b0001;
                    pm_reg <= ~pm_reg;
                end else if (hours == 4'b1001) begin // 1 and it's PM
                    hours <= 4'b1001;
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

assign hh = (hours == 4'b1000) ? 8'b00010010 : (hours == 4'b1001 && pm_reg == 1'b1) ? 8'b00010001 : (hours > 4'b1000 && hours < 4'b1010 && pm_reg == 1'b1) ? hours + 4'b0100 : hours;
assign mm = (minutes[5:4] == 2'b01) ? {minutes[5:4], 4'b0000} + 1'b1 : {minutes[5:4], 4'b0000} + minutes[3:0];
assign ss = (seconds[3:2] == 2'b05) ? {seconds[3:2], 4'b0000} + 1'b1 : {seconds[3:2], 4'b0000} + seconds[1:0];
assign pm = pm_reg;

endmodule