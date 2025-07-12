module TopModule(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

reg [5:0] sec;  // internal seconds counter
reg [5:0] min;  // internal minutes counter
reg [3:0] hour; // internal hours counter

always @(posedge clk) begin
    if (reset) begin  // synchronous reset
        sec <= 0;
        min <= 0;
        hour <= 0;  // 12:00 AM
        pm <= 0;
    end else if (ena) begin  // increment counters when ena is high
        if (sec == 59) begin  // seconds counter wrap-around
            sec <= 0;
            if (min == 59) begin  // minutes counter wrap-around
                min <= 0;
                if (hour == 11) begin  // 11:59 PM -> 12:00 AM
                    hour <= 0;
                    pm <= 0;
                end else if (hour == 12 - 1) begin  // 12:59 PM -> 1:00 PM
                    hour <= 1;
                    pm <= 1;
                end else if (hour == 11) begin  // 11:59 AM -> 12:00 PM
                    hour <= 12 - 1;
                    pm <= 1;
                end else begin  // increment hour
                    hour <= hour + 1;
                    if (hour >= 12) begin  // PM
                        pm <= 1;
                    end else begin  // AM
                        pm <= 0;
                    end
                end
            end else begin  // increment minutes
                min <= min + 1;
            end
        end else begin  // increment seconds
            sec <= sec + 1;
        end
    end
end

always @(*) begin  // continuous assignment
    // BCD encoding for hours, minutes, and seconds
    hh[7:4] = hour[3:0];
    hh[3:0] = 0;
    mm[7:4] = min[5:4];
    mm[3:0] = min[3:0];
    ss[7:4] = sec[5:4];
    ss[3:0] = sec[3:0];
end

endmodule