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

always @(posedge clk) begin
    if (reset) begin
        hours_tens <= 4'd1;
        hours_ones <= 4'd2;
        minutes_tens <= 4'd0;
        minutes_ones <= 4'd0;
        seconds_tens <= 4'd0;
        seconds_ones <= 4'd0;
    end else if (ena) begin
        if (seconds_ones == 4'd9 && seconds_tens == 4'd5) begin
            seconds_tens <= 4'd0;
            seconds_ones <= 4'd0;
            if (minutes_ones == 4'd9 && minutes_tens == 4'd5) begin
                minutes_tens <= 4'd0;
                minutes_ones <= 4'd0;
                if (hours_ones == 4'd9 && hours_tens == 4'd1) begin
                    hours_tens <= 4'd1;
                    hours_ones <= 4'd2;
                end else if (hours_ones == 4'd2 && hours_tens == 4'd1) begin
                    hours_tens <= 4'd0;
                    hours_ones <= 4'd1;
                end else if (hours_ones == 4'd9 && hours_tens == 4'd0) begin
                    hours_tens <= 4'd1;
                    hours_ones <= 4'd0;
                end else begin
                    hours_ones <= hours_ones + 4'd1;
                    if (hours_ones == 4'd3 && hours_tens == 4'd0) begin
                        hours_tens <= 4'd1;
                        hours_ones <= 4'd0;
                    end
                end
            end else if (minutes_ones == 4'd9) begin
                minutes_ones <= 4'd0;
                minutes_tens <= minutes_tens + 4'd1;
            end else begin
                minutes_ones <= minutes_ones + 4'd1;
            end
        end else if (seconds_ones == 4'd9) begin
            seconds_ones <= 4'd0;
            seconds_tens <= seconds_tens + 4'd1;
        end else begin
            seconds_ones <= seconds_ones + 4'd1;
        end
    end
end

assign pm = (hours_tens == 4'd0) ? 1'b0 : 1'b1;

assign hh = {hours_tens, hours_ones};
assign mm = {minutes_tens, minutes_ones};
assign ss = {seconds_tens, seconds_ones};

endmodule