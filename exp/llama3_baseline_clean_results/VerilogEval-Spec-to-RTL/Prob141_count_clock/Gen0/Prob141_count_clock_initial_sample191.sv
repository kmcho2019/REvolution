module TopModule(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

reg [3:0] hours_tens;
reg [3:0] hours_ones;
reg [3:0] minutes_tens;
reg [3:0] minutes_ones;
reg [3:0] seconds_tens;
reg [3:0] seconds_ones;

always @(posedge clk) begin
    if (reset) begin
        hours_tens <= 0;
        hours_ones <= 2; // 12
        minutes_tens <= 0;
        minutes_ones <= 0;
        seconds_tens <= 0;
        seconds_ones <= 0;
        pm <= 0; // AM
    end else if (ena) begin
        // increment seconds
        if (seconds_ones == 9) begin
            seconds_ones <= 0;
            if (seconds_tens == 5) begin
                seconds_tens <= 0;
                // increment minutes
                if (minutes_ones == 9) begin
                    minutes_ones <= 0;
                    if (minutes_tens == 5) begin
                        minutes_tens <= 0;
                        // increment hours
                        if (hours_ones == 9) begin
                            hours_ones <= 2; // wrap around to 12
                            if (hours_tens == 1) begin
                                hours_tens <= 0;
                                pm <= ~pm; // toggle AM/PM
                            end else begin
                                hours_tens <= 1;
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

assign hh = {4'd0, hours_tens, hours_ones};
assign mm = {4'd0, minutes_tens, minutes_ones};
assign ss = {4'd0, seconds_tens, seconds_ones};

endmodule