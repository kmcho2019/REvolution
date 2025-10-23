module TopModule(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

reg [7:0] hours;
reg [7:0] minutes;
reg [7:0] seconds;
reg pm_reg;

assign hh = hours;
assign mm = minutes;
assign ss = seconds;
assign pm = pm_reg;

always @(posedge clk) begin
    if (reset) begin
        hours <= 8'h12; // 12 in BCD
        minutes <= 8'h00;
        seconds <= 8'h00;
        pm_reg <= 1'b0; // AM
    end else if (ena) begin
        if (seconds == 8'h59) begin // 59 in BCD
            seconds <= 8'h00;
            if (minutes == 8'h59) begin // 59 in BCD
                minutes <= 8'h00;
                if (hours == 8'h12) begin // 12 in BCD
                    hours <= 8'h01; // 1 in BCD
                    pm_reg <= ~pm_reg; // Toggle AM/PM
                end else if (hours == 8'h01 && pm_reg == 1'b1) begin
                    hours <= 8'h12; // 12 in BCD
                    pm_reg <= 1'b0; // AM
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

endmodule