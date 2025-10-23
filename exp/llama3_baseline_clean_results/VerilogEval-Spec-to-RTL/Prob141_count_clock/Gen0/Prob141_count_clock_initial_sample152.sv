module TopModule(
    input  clk,
    input  reset,
    input  ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

reg [5:0] sec; // 0-59
reg [5:0] min; // 0-59
reg [3:0] hour; // 0-11
reg pm_reg;

always @(posedge clk) begin
    if (reset) begin
        sec <= 0;
        min <= 0;
        hour <= 0;
        pm_reg <= 0;
    end else if (ena) begin
        if (sec == 59) begin
            sec <= 0;
            if (min == 59) begin
                min <= 0;
                if (hour == 11) begin
                    hour <= 0;
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
assign hh = {4'b1, hour}; // convert 4-bit hour to 8-bit BCD
assign mm = {4'b0, min}; // convert 6-bit minute to 8-bit BCD
assign ss = {4'b0, sec}; // convert 6-bit second to 8-bit BCD

endmodule