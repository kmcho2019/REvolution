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
reg [5:0] minutes_tens;
reg [5:0] minutes_ones;
reg [5:0] seconds_tens;
reg [5:0] seconds_ones;

assign hh = {hours_tens, hours_ones};
assign mm = {minutes_tens, minutes_ones};
assign ss = {seconds_tens, seconds_ones};

always @ (posedge clk) begin
    if (reset) begin
        hours_tens <= 1;
        hours_ones <= 2;
        minutes_tens <= 0;
        minutes_ones <= 0;
        seconds_tens <= 0;
        seconds_ones <= 0;
    end else if (ena) begin
        if (seconds_ones == 9 && seconds_tens == 5) begin
            seconds_tens <= 0;
            seconds_ones <= 0;
            if (minutes_ones == 9 && minutes_tens == 5) begin
                minutes_tens <= 0;
                minutes_ones <= 0;
                if (hours_ones == 2 && hours_tens == 1) begin
                    hours_tens <= 1;
                    hours_ones <= 2; // 12:00 AM
                end else if (hours_ones == 9 && hours_tens == 1) begin
                    hours_tens <= 0;
                    hours_ones <= 1; // 1:00 AM/PM
                end else if (hours_ones == 9 && hours_tens == 0) begin
                    hours_tens <= 1;
                    hours_ones <= 2; // 12:00 PM
                end else if (hours_ones == 2 && hours_tens == 0) begin
                    hours_tens <= 1;
                    hours_ones <= 2; // 12:00 PM
                end else begin
                    hours_ones <= 0;
                end
            end else begin
                minutes_ones <= 0;
            end
        end else if (seconds_ones == 9) begin
            seconds_ones <= 0;
            seconds_tens <= seconds_tens + 1;
        end else begin
            seconds_ones <= seconds_ones + 1;
        end
    end
end

always @ (*) begin
    if (hours_tens == 0 && hours_ones >= 1 && hours_ones <= 9) begin
        pm <= 1'b1; // PM
    end else if (hours_tens == 0 && hours_ones == 0) begin
        pm <= 1'b0; // 12:00 AM
    end else if (hours_tens == 1 && hours_ones == 2) begin
        pm <= 1'b0; // 12:00 AM
    end else begin
        pm <= 1'b1; // PM
    end
end

endmodule