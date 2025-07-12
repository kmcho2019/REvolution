module TopModule (
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
reg pm_flag;

always @(posedge clk) begin
    if (reset) begin
        seconds <= 0;
        minutes <= 0;
        hours <= 12; // 12:00:00 AM
        pm_flag <= 0;
    end else if (ena) begin
        if (seconds == 59) begin
            seconds <= 0;
            if (minutes == 59) begin
                minutes <= 0;
                if (hours == 12) begin
                    hours <= 1;
                    pm_flag <= ~pm_flag;
                end else if (hours == 11) begin
                    hours <= 12;
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

assign pm = pm_flag;
assign hh = {4'b0000, hours / 10, hours % 10};
assign mm = {4'b0000, minutes / 10, minutes % 10};
assign ss = {4'b0000, seconds / 10, seconds % 10};

endmodule