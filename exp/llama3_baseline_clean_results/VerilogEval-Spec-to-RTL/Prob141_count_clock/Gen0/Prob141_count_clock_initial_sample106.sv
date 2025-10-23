module TopModule (
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
        hours_tens <= 4'b0001; // 1
        hours_ones <= 4'b0000; // 0
        minutes_tens <= 4'b0000; // 0
        minutes_ones <= 4'b0000; // 0
        seconds_tens <= 4'b0000; // 0
        seconds_ones <= 4'b0000; // 0
        pm_reg <= 1'b0; // AM
    end else if (ena) begin
        // seconds counter
        if (seconds_ones == 4'b1001) begin // 9
            seconds_ones <= 4'b0000; // 0
            if (seconds_tens == 4'b0101) begin // 5
                seconds_tens <= 4'b0000; // 0
                // minutes counter
                if (minutes_ones == 4'b1001) begin // 9
                    minutes_ones <= 4'b0000; // 0
                    if (minutes_tens == 4'b0101) begin // 5
                        minutes_tens <= 4'b0000; // 0
                        // hours counter
                        if (hours_ones == 4'b1001) begin // 9
                            hours_ones <= 4'b0000; // 0
                            if (hours_tens == 4'b0001) begin // 1
                                hours_tens <= 4'b0001; // 1
                                hours_ones <= 4'b0000; // 0
                                pm_reg <= ~pm_reg; // toggle AM/PM
                            end else begin
                                hours_tens <= hours_tens + 1'b1;
                            end
                        end else begin
                            hours_ones <= hours_ones + 1'b1;
                        end
                    end else begin
                        minutes_tens <= minutes_tens + 1'b1;
                    end
                end else begin
                    minutes_ones <= minutes_ones + 1'b1;
                end
            end else begin
                seconds_tens <= seconds_tens + 1'b1;
            end
        end else begin
            seconds_ones <= seconds_ones + 1'b1;
        end
    end
end

assign hh = {hours_tens, hours_ones};
assign mm = {minutes_tens, minutes_ones};
assign ss = {seconds_tens, seconds_ones};
assign pm = pm_reg;

endmodule