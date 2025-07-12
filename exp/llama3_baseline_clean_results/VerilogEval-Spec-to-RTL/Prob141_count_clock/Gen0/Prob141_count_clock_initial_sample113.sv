module TopModule (
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
reg pm_mode;

assign hh = {1'b0, hours[3:0]};
assign mm = {1'b0, minutes[5:4], minutes[3:0]};
assign ss = {1'b0, seconds[5:4], seconds[3:0]};
assign pm = pm_mode;

always @(posedge clk) begin
    if (reset) begin
        hours <= 4'b0001;  // 1
        minutes <= 6'b000000;  // 0
        seconds <= 6'b000000;  // 0
        pm_mode <= 1'b0;  // AM
    end else if (ena) begin
        if (seconds == 6'b001110) begin  // 60 - 1
            seconds <= 6'b000000;  // 0
            if (minutes == 6'b001110) begin  // 60 - 1
                minutes <= 6'b000000;  // 0
                if (hours == 4'b1100) begin  // 12
                    hours <= 4'b0001;  // 1
                    pm_mode <= ~pm_mode;  // toggle AM/PM
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