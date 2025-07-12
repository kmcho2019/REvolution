module TopModule(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

reg [5:0] sec; // 0-59
reg [5:0] min; // 0-59
reg [3:0] hour; // 1-12
reg pm_reg;

always @(posedge clk) begin
    if (reset) begin
        sec <= 0;
        min <= 0;
        hour <= 1; // 1 o'clock in BCD
        pm_reg <= 0; // AM
    end else if (ena) begin
        if (sec == 59) begin
            sec <= 0;
            if (min == 59) begin
                min <= 0;
                if (hour == 12) begin
                    hour <= 1; // wrap around to 1 o'clock
                    pm_reg <= ~pm_reg; // toggle AM/PM
                end else begin
                    hour <= hour + 1;
                end
            end else begin
                min <= min + 1;
            end
        end else begin
            sec <= sec + 1;
        end
    end
end

assign pm = (hour > 6)? 1'b1 : 1'b0;
assign hh = {4'd0, hour};
assign mm = {4'd0, min};
assign ss = {4'd0, sec};

endmodule