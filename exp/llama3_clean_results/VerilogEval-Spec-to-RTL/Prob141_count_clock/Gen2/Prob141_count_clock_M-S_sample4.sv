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

assign hh = {hours_tens, hours_ones};
assign mm = {minutes_tens, minutes_ones};
assign ss = {seconds_tens, seconds_ones};

initial begin
    hours_tens = 4'd0;
    hours_ones = 4'd1;
    minutes_tens = 4'd0;
    minutes_ones = 4'd0;
    seconds_tens = 4'd0;
    seconds_ones = 4'd0;
    pm = 1'b0;
end

always @(posedge clk) begin
    if (reset) begin
        hours_tens <= 4'd0;
        hours_ones <= 4'd1;
        minutes_tens <= 4'd0;
        minutes_ones <= 4'd0;
        seconds_tens <= 4'd0;
        seconds_ones <= 4'd0;
        pm <= 1'b0;
    end else if (ena) begin
        // Increment seconds
        if (seconds_ones == 4'd9) begin
            seconds_ones <= 4'd0;
            if (seconds_tens == 4'd5) begin
                seconds_tens <= 4'd0;
                // Increment minutes
                if (minutes_ones == 4'd9) begin
                    minutes_ones <= 4'd0;
                    if (minutes_tens == 4'd5) begin
                        minutes_tens <= 4'd0;
                        // Increment hours
                        if ((hours_tens == 4'd1 && hours_ones == 4'd2) || (hours_tens == 4'd0 && hours_ones == 4'd2)) begin
                            hours_tens <= 4'd0;
                            hours_ones <= 4'd1;
                            pm <= ~pm;
                        end else if (hours_tens == 4'd0 && hours_ones == 4'd9) begin
                            hours_tens <= 4'd1;
                            hours_ones <= 4'd0;
                        end else begin
                            if (hours_ones == 4'd9) begin
                                hours_ones <= 4'd0;
                                hours_tens <= hours_tens + 1'b1;
                            end else begin
                                hours_ones <= hours_ones + 1'b1;
                            end
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

endmodule