module TopModule(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

reg [5:0] seconds;
reg [5:0] minutes;
reg [4:0] hours;

always @(posedge clk) begin
    if (reset) begin
        seconds <= 0;
        minutes <= 0;
        hours <= 0;
        pm <= 1'b0; // Reset to AM
    end else if (ena) begin
        if (seconds == 59) begin
            seconds <= 0;
            if (minutes == 59) begin
                minutes <= 0;
                if (hours == 11) begin
                    hours <= 0;
                    pm <= ~pm; // Toggle AM/PM
                end else begin
                    hours <= hours + 1;
                end
            end else begin
                minutes <= minutes + 1;
            end
        end else begin
            seconds <= seconds + 1;
        end
    end
end

always @(*) begin
    if (hours == 0) begin
        hh = 12; // 12-hour clock
    end else begin
        hh = hours + 1;
    end

    mm = minutes;
    ss = seconds;

    if (hours >= 6 && hours < 12) begin
        pm = 1'b1; // PM
    end else begin
        pm = 1'b0; // AM
    end
end

endmodule