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
    if (reset) begin // Reset has higher priority
        hour <= 4'd1; // 12:00 AM
        minute <= 6'd0;
        second <= 6'd0;
        pm_reg <= 1'b0; // AM
    end else if (ena) begin
        if (second == 6'd59) begin // Roll over seconds
            second <= 6'd0;
            if (minute == 6'd59) begin // Roll over minutes
                minute <= 6'd0;
                if (hour == 4'd12) begin // Roll over hours, switch AM/PM
                    hour <= 4'd1;
                    pm_reg <= ~pm_reg; // Toggle AM/PM
                end else if (hour == 4'd12 - 1) begin // Special case for 11 AM/PM transition
                    hour <= 4'd12;
                    pm_reg <= ~pm_reg; // Toggle AM/PM
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

assign hh = {4'd0, hour}; // Pad with leading zeros for BCD display
assign mm = {2'd0, minute[5:4], minute[3:0]}; // Format minutes for BCD display
assign ss = {2'd0, second[5:4], second[3:0]}; // Format seconds for BCD display
assign pm = pm_reg;

endmodule