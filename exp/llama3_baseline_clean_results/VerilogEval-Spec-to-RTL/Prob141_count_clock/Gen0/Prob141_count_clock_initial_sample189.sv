module TopModule(
    input  clk,
    input  reset,
    input  ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

reg [3:0] hours;
reg [5:0] minutes;
reg [5:0] seconds;
reg pm_reg;

always @(posedge clk) begin
    if (reset) begin
        hours <= 4'd0; // 12 in BCD is 0001, but we'll use 0000 for simplicity
        minutes <= 6'd0;
        seconds <= 6'd0;
        pm_reg <= 1'b0;
    end
    else if (ena) begin
        if (seconds == 6'd59) begin
            seconds <= 6'd0;
            if (minutes == 6'd59) begin
                minutes <= 6'd0;
                if (hours == 4'd11) begin // 11 in BCD is 1001
                    hours <= 4'd0; // wrap around to 12 AM
                    pm_reg <= 1'b0;
                end
                else if (hours == 4'd12) begin // 12 in BCD is 1100
                    hours <= 4'd1; // 1 PM
                    pm_reg <= 1'b1;
                end
                else if (hours == 4'd12 + 1'd11) begin // 11 PM
                    hours <= 4'd12; // 12 PM
                    pm_reg <= 1'b1;
                end
                else begin
                    hours <= hours + 1'd1;
                    if (hours[3]) // if hours is greater than or equal to 10
                        pm_reg <= 1'b1;
                    else
                        pm_reg <= 1'b0;
                end
            end
            else begin
                minutes <= minutes + 1'd1;
            end
        end
        else begin
            seconds <= seconds + 1'd1;
        end
    end
end

assign hh = {4'd0, hours};
assign mm = {2'd0, minutes[5:4], minutes[3:0]};
assign ss = {2'd0, seconds[5:4], seconds[3:0]};
assign pm = pm_reg;

endmodule