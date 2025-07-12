module TopModule(
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
        seconds <= 8'd0;
        minutes <= 8'd0;
        hours <= 8'd12;
        pm_reg <= 1'b0;
    end else if (ena) begin
        if (seconds == 8'd59) begin
            seconds <= 8'd0;
            if (minutes == 8'd59) begin
                minutes <= 8'd0;
                if (hours == 8'd12) begin
                    hours <= 8'd1;
                    pm_reg <= ~pm_reg;
                end else if (hours == 8'd12 - 1) begin
                    hours <= 8'd12;
                end else begin
                    hours <= hours + 8'd1;
                end
            end else begin
                minutes <= minutes + 8'd1;
            end
        end else begin
            seconds <= seconds + 8'd1;
        end
    end
end

assign pm = pm_reg;
assign hh = hours;
assign mm = minutes;
assign ss = seconds;

endmodule