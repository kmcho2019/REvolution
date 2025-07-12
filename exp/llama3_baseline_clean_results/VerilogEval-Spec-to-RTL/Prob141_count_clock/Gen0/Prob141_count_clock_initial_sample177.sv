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
reg pmReg;

always @(posedge clk) begin
    if (reset) begin
        hours <= 0;
        minutes <= 0;
        seconds <= 0;
        pmReg <= 0;
    end else if (ena) begin
        if (seconds == 59) begin
            seconds <= 0;
            if (minutes == 59) begin
                minutes <= 0;
                if (hours == 11) begin
                    hours <= 0;
                    pmReg <= ~pmReg;
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

assign hh = {1'b0, hours, 4'b0000};
assign mm = {2'b00, minutes[4:0], 2'b00};
assign ss = {2'b00, seconds[4:0], 2'b00};
assign pm = pmReg;

endmodule