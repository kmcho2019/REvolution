module TopModule(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

reg [3:0] hour;
reg [5:0] minute;
reg [5:0] second;
reg pm_reg;

always @(posedge clk) begin
    if (reset) begin
        hour <= 4'd1;
        minute <= 6'd0;
        second <= 6'd0;
        pm_reg <= 1'b0;
    end else if (ena) begin
        if (second == 6'd59) begin
            second <= 6'd0;
            if (minute == 6'd59) begin
                minute <= 6'd0;
                if (hour == 4'd12) begin
                    hour <= 4'd1;
                    pm_reg <= ~pm_reg;
                end else begin
                    hour <= hour + 1;
                end
            end else begin
                minute <= minute + 1;
            end
        end else begin
            second <= second + 1;
        end
    end
end

assign hh = {4'd0, hour};
assign mm = {2'd0, minute[5:4], minute[3:0]};
assign ss = {2'd0, second[5:4], second[3:0]};
assign pm = pm_reg;

endmodule