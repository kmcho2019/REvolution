module TopModule(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

reg [3:0] seconds;
reg [3:0] minutes;
reg [3:0] hours;

assign hh = (hours > 6) ? {1'b0, hours - 6} : {1'b0, hours};
assign mm = (minutes > 5) ? {1'b0, minutes - 6} : {1'b0, minutes};
assign ss = (seconds > 5) ? {1'b0, seconds - 6} : {1'b0, seconds};
assign pm = (hours >= 6) ? 1'b1 : 1'b0;

always @(posedge clk) begin
    if (reset) begin
        seconds <= 0;
        minutes <= 0;
        hours <= 0;
    end else if (ena) begin
        if (seconds == 9) begin
            seconds <= 0;
            if (minutes == 9) begin
                minutes <= 0;
                if (hours == 11) begin
                    hours <= 0;
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

endmodule