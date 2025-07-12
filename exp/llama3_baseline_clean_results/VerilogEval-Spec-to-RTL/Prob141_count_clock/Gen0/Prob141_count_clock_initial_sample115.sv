module TopModule(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

reg [3:0] hour_tens;
reg [3:0] hour_ones;
reg [3:0] minute_tens;
reg [3:0] minute_ones;
reg [3:0] second_tens;
reg [3:0] second_ones;
reg pm_reg;

always @(posedge clk) begin
    if (reset) begin
        hour_tens <= 4'd1;
        hour_ones <= 4'd2;
        minute_tens <= 4'd0;
        minute_ones <= 4'd0;
        second_tens <= 4'd0;
        second_ones <= 4'd0;
        pm_reg <= 1'b0;
    end else if (ena) begin
        if (second_ones == 4'd9) begin
            second_ones <= 4'd0;
            if (second_tens == 4'd5) begin
                second_tens <= 4'd0;
                if (minute_ones == 4'd9) begin
                    minute_ones <= 4'd0;
                    if (minute_tens == 4'd5) begin
                        minute_tens <= 4'd0;
                        if (hour_ones == 4'd9) begin
                            hour_ones <= 4'd1;
                            if (hour_tens == 4'd1) begin
                                hour_tens <= 4'd0;
                                pm_reg <= ~pm_reg;
                            end else if (hour_tens == 4'd2) begin
                                hour_tens <= 4'd1;
                            end
                        end else if (hour_ones == 4'd2 && hour_tens == 4'd1) begin
                            hour_ones <= 4'd1;
                            hour_tens <= 4'd0;
                        end else if (hour_ones == 4'd3 && hour_tens == 4'd1) begin
                            hour_ones <= 4'd1;
                            hour_tens <= 4'd0;
                            pm_reg <= ~pm_reg;
                        end else begin
                            hour_ones <= hour_ones + 1'b1;
                        end
                    end else if (minute_tens == 4'd0 || minute_tens == 4'd1 || minute_tens == 4'd2 || minute_tens == 4'd3 || minute_tens == 4'd4) begin
                        minute_ones <= minute_ones + 1'b1;
                    end
                end else if (minute_ones == 4'd0 || minute_ones == 4'd1 || minute_ones == 4'd2 || minute_ones == 4'd3 || minute_ones == 4'd4 || minute_ones == 4'd5 || minute_ones == 4'd6 || minute_ones == 4'd7 || minute_ones == 4'd8) begin
                    minute_ones <= minute_ones + 1'b1;
                end
            end else if (second_tens == 4'd0 || second_tens == 4'd1 || second_tens == 4'd2 || second_tens == 4'd3 || second_tens == 4'd4) begin
                second_ones <= second_ones + 1'b1;
            end
        end else begin
            second_ones <= second_ones + 1'b1;
        end
    end
end

assign pm = pm_reg;
assign hh = {hour_tens, hour_ones};
assign mm = {minute_tens, minute_ones};
assign ss = {second_tens, second_ones};

endmodule