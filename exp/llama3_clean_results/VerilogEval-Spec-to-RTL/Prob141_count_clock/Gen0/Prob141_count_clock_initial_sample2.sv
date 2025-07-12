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

assign hh = {hours_tens, hours_ones};
assign mm = {minutes_tens, minutes_ones};
assign ss = {seconds_tens, seconds_ones};

always @(posedge clk) begin
    if (reset) begin
        hours_tens <= 1;
        hours_ones <= 2;
        minutes_tens <= 0;
        minutes_ones <= 0;
        seconds_tens <= 0;
        seconds_ones <= 0;
    end else if (ena) begin
        if (seconds_ones == 9) begin
            seconds_ones <= 0;
            if (seconds_tens == 5) begin
                seconds_tens <= 0;
                if (minutes_ones == 9) begin
                    minutes_ones <= 0;
                    if (minutes_tens == 5) begin
                        minutes_tens <= 0;
                        if (hours_ones == 9) begin
                            hours_ones <= 1;
                            if (hours_tens == 1) begin
                                hours_tens <= 0;
                            end else begin
                                hours_tens <= hours_tens + 1;
                            end
                        end else begin
                            hours_ones <= hours_ones + 1;
                        end
                    end else begin
                        minutes_tens <= minutes_tens + 1;
                    end
                end else begin
                    minutes_ones <= minutes_ones + 1;
                end
            end else begin
                seconds_tens <= seconds_tens + 1;
            end
        end else begin
            seconds_ones <= seconds_ones + 1;
        end
    end
end

assign pm = (hours_tens == 0 && hours_ones >= 6) || (hours_tens == 1 && hours_ones < 6);

endmodule