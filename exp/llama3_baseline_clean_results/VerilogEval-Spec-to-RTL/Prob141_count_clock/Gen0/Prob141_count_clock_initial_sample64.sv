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
reg [3:0] minutes;
reg [3:0] hours;
reg pm_reg;

always @(posedge clk) begin
    if (reset) begin
        seconds <= 4'b0000;
        minutes <= 4'b0000;
        hours <= 4'b0001;
        pm_reg <= 1'b0;
    end else if (ena) begin
        if (seconds == 4'd59) begin
            seconds <= 4'b0000;
            if (minutes == 4'd59) begin
                minutes <= 4'b0000;
                if (hours == 4'd12) begin
                    hours <= 4'b0001;
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

assign hh = {4'b0000, hours};
assign mm = {4'b0000, minutes};
assign ss = {4'b0000, seconds};
assign pm = pm_reg;

endmodule