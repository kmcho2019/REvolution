module TopModule (
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

reg [31:0] slow_counter;
reg [7:0] seconds;
reg [7:0] minutes;
reg [7:0] hours;

always @(posedge clk) begin
    if (reset) begin
        pm <= 0;
        seconds <= 8'b0000_0000;
        minutes <= 8'b0000_0000;
        hours <= 8'b0001_0010;  // BCD for 12
        slow_counter <= 32'd0;
    end else if (ena) begin
        if (slow_counter == 32'd0) begin
            if (seconds == 8'b0101_1001) begin  // 59 in BCD
                seconds <= 8'b0000_0000;
                if (minutes == 8'b0101_1001) begin  // 59 in BCD
                    minutes <= 8'b0000_0000;
                    if (hours == 8'b0001_0010) begin  // 12 in BCD, AM
                        hours <= 8'b0001_0010;
                        pm <= 1;
                    end else if (hours == 8'b0001_0011) begin  // 12 in BCD, PM
                        hours <= 8'b0001_0000;  // 1 in BCD
                        pm <= 0;
                    end else begin
                        hours <= hours + 1;
                        if (hours[3:0] == 4'b1001) begin  // 9 in BCD
                            hours[3:0] <= 4'b0000;
                            hours[7:4] <= hours[7:4] + 1;
                        end
                        if (hours == 8'b0001_0010 && pm == 0) begin  // 12 in BCD, AM
                            pm <= 1;
                        end else if (hours == 8'b0001_0010 && pm == 1) begin  // 12 in BCD, PM
                            pm <= 0;
                        end
                    end
                end else begin
                    minutes <= minutes + 1;
                    if (minutes[3:0] == 4'b1001) begin  // 9 in BCD
                        minutes[3:0] <= 4'b0000;
                        minutes[7:4] <= minutes[7:4] + 1;
                    end
                end
            end else begin
                seconds <= seconds + 1;
                if (seconds[3:0] == 4'b1001) begin  // 9 in BCD
                    seconds[3:0] <= 4'b0000;
                    seconds[7:4] <= seconds[7:4] + 1;
                end
            end
            slow_counter <= 32'd100000000;  // assume clk is 100MHz, 100000000/100000000 = 1 second
        end else begin
            slow_counter <= slow_counter - 1;
        end
    end else begin
        slow_counter <= slow_counter - 1;
    end

    hh <= hours;
    mm <= minutes;
    ss <= seconds;
end

endmodule