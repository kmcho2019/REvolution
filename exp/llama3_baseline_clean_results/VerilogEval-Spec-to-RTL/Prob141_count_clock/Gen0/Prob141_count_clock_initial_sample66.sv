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

assign hh = {4'd0, hours};
assign mm = {4'd0, minutes};
assign ss = {4'd0, seconds};
assign pm = (hours > 5);

always @(posedge clk) begin
    if (reset) begin
        seconds <= 4'd0;
        minutes <= 4'd0;
        hours <= 4'd1;
    end else if (ena) begin
        if (seconds == 4'd59) begin
            seconds <= 4'd0;
            if (minutes == 4'd59) begin
                minutes <= 4'd0;
                if (hours == 4'd12) begin
                    hours <= 4'd1;
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