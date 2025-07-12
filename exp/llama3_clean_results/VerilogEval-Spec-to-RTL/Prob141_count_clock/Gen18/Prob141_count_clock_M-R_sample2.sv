module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

reg [5:0] seconds;
reg [5:0] minutes;
reg [3:0] hours;

always_ff @(posedge clk) begin
    if (reset) begin
        seconds <= 6'd0;
        minutes <= 6'd0;
        hours <= 4'd0;
    end else if (ena) begin
        if (seconds == 6'd59) begin
            seconds <= 6'd0;
            if (minutes == 6'd59) begin
                minutes <= 6'd0;
                if (hours == 4'd11) begin
                    hours <= 4'd0;
                end else begin
                    hours <= hours + 4'd1;
                end
            end else begin
                minutes <= minutes + 6'd1;
            end
        end else begin
            seconds <= seconds + 6'd1;
        end
    end
end

assign pm = (hours >= 4'd12) ? 1'b1 : 1'b0;
assign hh = {4'b0000, (hours >= 4'd12) ? hours - 4'd12 : hours};
assign mm = {4'b0000, minutes / 10, minutes % 10};
assign ss = {4'b0000, seconds / 10, seconds % 10};

endmodule