module TopModule(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

reg [3:0] sec;
reg [3:0] min;
reg [3:0] hour;
reg pm_reg;

always @(posedge clk) begin
    if (reset) begin
        sec <= 0;
        min <= 0;
        hour <= 1;
        pm_reg <= 0;
    end else if (ena) begin
        if (sec == 9'd59) begin
            sec <= 0;
            if (min == 9'd59) begin
                min <= 0;
                if (hour == 9'd12) begin
                    hour <= 1;
                    pm_reg <= ~pm_reg;
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

assign pm = pm_reg;
assign hh = {4'b0, hour};
assign mm = {4'b0, min};
assign ss = {4'b0, sec};

endmodule