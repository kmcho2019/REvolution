module TopModule(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

reg [3:0] hours;
reg [5:0] minutes;
reg [5:0] seconds;

always @(posedge clk) begin
    if (reset) begin
        hours <= 4'd0;
        minutes <= 6'd0;
        seconds <= 6'd0;
        pm <= 1'b0;
    end else if (ena) begin
        seconds <= seconds + 1'b1;
        if (seconds == 6'd59) begin
            seconds <= 6'd0;
            minutes <= minutes + 1'b1;
            if (minutes == 6'd59) begin
                minutes <= 6'd0;
                hours <= hours + 1'b1;
                if (hours == 4'd12) begin
                    hours <= 4'd0;
                end
                if (hours >= 4'd12) begin
                    pm <= 1'b1;
                end else begin
                    pm <= 1'b0;
                end
            end
        end
    end
end

always @(hours, minutes, seconds) begin
    hh[7:4] <= 4'd0;
    hh[3:0] <= hours;
    mm[7:6] <= 2'd0;
    mm[5:0] <= minutes;
    ss[7:6] <= 2'd0;
    ss[5:0] <= seconds;
end

endmodule