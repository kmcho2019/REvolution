module TopModule(
    input clk,
    input reset,
    input ena,
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
        seconds <= 0;
        minutes <= 0;
        hours <= 1;  // 1 corresponds to 01 in BCD
        pm_reg <= 0;
    end else if (ena) begin
        if (seconds == 9'd59) begin
            seconds <= 0;
            if (minutes == 9'd59) begin
                minutes <= 0;
                if (hours == 9'd12) begin
                    hours <= 1;  // 1 corresponds to 01 in BCD
                    pm_reg <= ~pm_reg;
                end else if (hours == 9'd11) begin
                    hours <= 9'd12;
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
assign hh = {4'b0, hours};  // pad with zeros to 8 bits
assign mm = {4'b0, minutes};  // pad with zeros to 8 bits
assign ss = {4'b0, seconds};  // pad with zeros to 8 bits

endmodule