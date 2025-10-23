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
reg am_pm;

always @(posedge clk) begin
    if (reset) begin
        hours <= 1;
        minutes <= 0;
        seconds <= 0;
        am_pm <= 0;
    end else if (ena) begin
        if (seconds == 59) begin
            seconds <= 0;
            if (minutes == 59) begin
                minutes <= 0;
                if (hours == 12) begin
                    hours <= 1;
                    am_pm <= ~am_pm;
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

assign pm = am_pm;
assign hh = {4'b0, hours};
assign mm = {2'b0, minutes};
assign ss = {2'b0, seconds};

endmodule