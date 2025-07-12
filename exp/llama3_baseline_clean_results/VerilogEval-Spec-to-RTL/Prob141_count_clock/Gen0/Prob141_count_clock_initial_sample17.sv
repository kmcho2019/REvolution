module TopModule(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

reg [3:0] hour_tens;
reg [3:0] hour_ones;
reg [5:0] minute_tens;
reg [5:0] minute_ones;
reg [5:0] second_tens;
reg [5:0] second_ones;

always @(posedge clk) begin
    if (reset) begin
        hour_tens <= 0;
        hour_ones <= 1; // 12
        minute_tens <= 0;
        minute_ones <= 0;
        second_tens <= 0;
        second_ones <= 0;
        pm <= 0;
    end else if (ena) begin
        if (second_ones == 9 && second_tens == 5) begin // 59
            second_ones <= 0;
            second_tens <= 0;
            if (minute_ones == 9 && minute_tens == 5) begin // 59
                minute_ones <= 0;
                minute_tens <= 0;
                if (hour_ones == 9 && hour_tens == 1) begin // 12
                    hour_ones <= 1; // 1
                    hour_tens <= 0;
                    pm <= ~pm;
                end else if (hour_ones == 2 && hour_tens == 1) begin // 12
                    hour_ones <= 1; // 1
                    hour_tens <= 0;
                end else if (hour_ones == 3 && hour_tens == 1) begin // 12
                    hour_ones <= 1; // 1
                    hour_tens <= 0;
                end else if (hour_ones == 4 && hour_tens == 1) begin // 12
                    hour_ones <= 1; // 1
                    hour_tens <= 0;
                end else if (hour_ones == 5 && hour_tens == 1) begin // 12
                    hour_ones <= 1; // 1
                    hour_tens <= 0;
                end else if (hour_ones == 6 && hour_tens == 1) begin // 12
                    hour_ones <= 1; // 1
                    hour_tens <= 0;
                end else if (hour_ones == 7 && hour_tens == 1) begin // 12
                    hour_ones <= 1; // 1
                    hour_tens <= 0;
                end else if (hour_ones == 8 && hour_tens == 1) begin // 12
                    hour_ones <= 1; // 1
                    hour_tens <= 0;
                end else if (hour_ones == 9 && hour_tens == 1) begin // 12
                    hour_ones <= 1; // 1
                    hour_tens <= 0;
                end else if (hour_ones == 2 && hour_tens == 0) begin // 2
                    hour_ones <= 3; // 3
                    hour_tens <= 0;
                end else if (hour_ones == 3 && hour_tens == 0) begin // 3
                    hour_ones <= 4; // 4
                    hour_tens <= 0;
                end else if (hour_ones == 4 && hour_tens == 0) begin // 4
                    hour_ones <= 5; // 5
                    hour_tens <= 0;
                end else if (hour_ones == 5 && hour_tens == 0) begin // 5
                    hour_ones <= 6; // 6
                    hour_tens <= 0;
                end else if (hour_ones == 6 && hour_tens == 0) begin // 6
                    hour_ones <= 7; // 7
                    hour_tens <= 0;
                end else if (hour_ones == 7 && hour_tens == 0) begin // 7
                    hour_ones <= 8; // 8
                    hour_tens <= 0;
                end else if (hour_ones == 8 && hour_tens == 0) begin // 8
                    hour_ones <= 9; // 9
                    hour_tens <= 0;
                end else if (hour_ones == 9 && hour_tens == 0) begin // 9
                    hour_ones <= 1; // 10
                    hour_tens <= 1;
                end else if (hour_ones == 1 && hour_tens == 1) begin // 10
                    hour_ones <= 2; // 11
                    hour_tens <= 1;
                end else if (hour_ones == 2 && hour_tens == 1) begin // 11
                    hour_ones <= 1; // 12
                    hour_tens <= 0;
                end else begin
                    hour_ones <= hour_ones + 1;
                end
            end else if (minute_ones == 9) begin // 59
                minute_ones <= 0;
                minute_tens <= minute_tens + 1;
            end else begin
                minute_ones <= minute_ones + 1;
            end
        end else if (second_ones == 9) begin // 59
            second_ones <= 0;
            second_tens <= second_tens + 1;
        end else begin
            second_ones <= second_ones + 1;
        end
    end
end

always @(posedge clk) begin
    if (hour_tens == 1) begin
        pm <= 1;
    end else begin
        pm <= 0;
    end
end

assign hh = {hour_tens, hour_ones};
assign mm = {minute_tens, minute_ones};
assign ss = {second_tens, second_ones};

endmodule