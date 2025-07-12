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
        hours <= 0;  // 12:00 AM
        minutes <= 0;
        seconds <= 0;
        pm <= 1'b0;  // AM
    end else if (ena) begin
        if (seconds == 6'd59) begin
            seconds <= 0;
            if (minutes == 6'd59) begin
                minutes <= 0;
                if (hours == 4'd12) begin
                    hours <= 1;
                    pm <= ~pm;
                end else if (hours == 4'd0) begin
                    hours <= 12;
                    pm <= 1'b0;
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
    hh = {4'b0000, hours};
    mm = {2'b00, minutes};
    ss = {2'b00, seconds};
end

endmodule