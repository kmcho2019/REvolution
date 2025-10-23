module TopModule(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

reg [7:0] hours;
reg [7:0] minutes;
reg [7:0] seconds;

assign hh = (hours > 12) ? hours - 12 : hours;
assign mm = minutes;
assign ss = seconds;

assign pm = (hours >= 12) ? 1'b1 : 1'b0;

always @(posedge clk) begin
    if (reset) begin
        hours <= 8'd12;
        minutes <= 8'd0;
        seconds <= 8'd0;
    end else if (ena) begin
        if (seconds == 8'd59) begin
            seconds <= 8'd0;
            if (minutes == 8'd59) begin
                minutes <= 8'd0;
                if (hours == 8'd12) begin
                    hours <= 8'd1;
                end else if (hours == 8'd23) begin
                    hours <= 8'd12;
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