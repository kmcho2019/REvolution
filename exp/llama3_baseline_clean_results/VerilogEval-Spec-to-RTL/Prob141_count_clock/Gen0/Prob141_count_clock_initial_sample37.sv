module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

reg [7:0] seconds;
reg [7:0] minutes;
reg [7:0] hours;
reg pm_reg;

always @(posedge clk) begin
    if (reset) begin
        seconds <= 0;
        minutes <= 0;
        hours <= 12;
        pm_reg <= 0;
    end else if (ena) begin
        if (seconds == 59) begin
            seconds <= 0;
            if (minutes == 59) begin
                minutes <= 0;
                if (hours == 12) begin
                    hours <= 1;
                    pm_reg <= ~pm_reg;
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

assign pm = pm_reg;
assign hh = {4'b0, hours};
assign mm = {4'b0, minutes};
assign ss = {4'b0, seconds};

endmodule