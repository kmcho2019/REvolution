module TopModule(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

reg [3:0] hours_tens;
reg [3:0] hours_ones;
reg [3:0] minutes_tens;
reg [3:0] minutes_ones;
reg [3:0] seconds_tens;
reg [3:0] seconds_ones;
reg pm_reg;

always @(posedge clk) begin
    if (reset) begin
        hours_tens <= 0;
        hours_ones <= 1;
        minutes_tens <= 0;
        minutes_ones <= 0;
        seconds_tens <= 0;
        seconds_ones <= 0;
        pm_reg <= 0;
    end else if (ena) begin
        if (seconds_ones == 9 && seconds_tens == 5) begin
            seconds_tens <= 0;
            seconds_ones <= 0;
            if (minutes_ones == 9 && minutes_tens == 5) begin
                minutes_tens <= 0;
                minutes_ones <= 0;
                if (hours_ones == 2 && hours_tens == 1) begin
                    hours_tens <= 0;
                    hours_ones <= 1;
                    pm_reg <= ~pm_reg;
                end else if (hours_ones == 2 && hours_tens == 0) begin
                    hours_tens <= 0;
                    hours_ones <= 1;
                end else if (hours_ones == 9 && hours_tens == 0) begin
                    hours_tens <= 1;
                    hours_ones <= 0;
                end else if (hours_ones == 9 && hours_tens == 1) begin
                    hours_tens <= 0;
                    hours_ones <= 2;
                end else begin
                    hours_ones <= hours_ones + 1;
                end
            end else if (minutes_ones == 9) begin
                minutes_ones <= 0;
                minutes_tens <= minutes_tens + 1;
            end else begin
                minutes_ones <= minutes_ones + 1;
            end
        end else if (seconds_ones == 9) begin
            seconds_ones <= 0;
            seconds_tens <= seconds_tens + 1;
        end else begin
            seconds_ones <= seconds_ones + 1;
        end
    end
end

assign pm = pm_reg;
assign hh = {4'd0, hours_tens, hours_ones};
assign mm = {4'd0, minutes_tens, minutes_ones};
assign ss = {4'd0, seconds_tens, seconds_ones};

endmodule