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

assign pm = pm_reg;
assign hh = {hour[3], hour[2:0], 4'b0000};
assign mm = {min[3], min[2:0], 4'b0000};
assign ss = {sec[3], sec[2:0], 4'b0000};

always @(posedge clk) begin
    if (reset) begin
        sec <= 4'b0000;
        min <= 4'b0000;
        hour <= 4'b0001;
        pm_reg <= 1'b0;
    end else if (ena) begin
        if (sec == 4'd59) begin
            sec <= 4'b0000;
            if (min == 4'd59) begin
                min <= 4'b0000;
                if (hour == 4'd12) begin
                    hour <= 4'b0001;
                    pm_reg <= 1'b0;
                end else if (hour == 4'd12 + 1) begin
                    hour <= 4'b0001;
                    pm_reg <= 1'b1;
                end else begin
                    hour <= hour + 1;
                    if (hour[3] == 1'b1) begin
                        pm_reg <= 1'b1;
                    end else begin
                        pm_reg <= 1'b0;
                    end
                end
            end else begin
                min <= min + 1;
            end
        end else begin
            sec <= sec + 1;
        end
    end
end

endmodule