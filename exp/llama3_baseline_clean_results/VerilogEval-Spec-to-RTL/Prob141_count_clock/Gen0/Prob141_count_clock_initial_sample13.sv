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
reg am_pm;

always @(posedge clk) begin
    if (reset) begin
        hours <= 8'h12; // 12 in BCD
        minutes <= 8'h00; // 00 in BCD
        seconds <= 8'h00; // 00 in BCD
        am_pm <= 1'b0; // AM
    end else if (ena) begin
        if (seconds == 8'h59) begin
            seconds <= 8'h00;
            if (minutes == 8'h59) begin
                minutes <= 8'h00;
                if (hours == 8'h12) begin
                    hours <= 8'h01; // 01 in BCD
                    am_pm <= ~am_pm;
                end else if (hours == 8'h12 + 8'h12) begin
                    hours <= 8'h01; // 01 in BCD
                    am_pm <= ~am_pm;
                end else begin
                    hours <= hours + 8'h01;
                end
            end else begin
                minutes <= minutes + 8'h01;
            end
        end else begin
            seconds <= seconds + 8'h01;
        end
    end
end

assign pm = am_pm;
assign hh = hours;
assign mm = minutes;
assign ss = seconds;

endmodule