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
reg [5:0] minutes;
reg [3:0] hours;

assign pm = hours[3];
assign hh = {1'b0, hours[2:0]};
assign mm = {1'b0, minutes[4:0]};
assign ss = {1'b0, seconds};

always @(posedge clk) begin
    if (reset) begin
        seconds <= 4'd0;
        minutes <= 4'd0;
        hours <= 4'd0;
    end else if (ena) begin
        if (seconds == 4'd59) begin
            seconds <= 4'd0;
            if (minutes == 6'd59) begin
                minutes <= 6'd0;
                if (hours == 4'd11) begin
                    hours <= 4'd0;
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