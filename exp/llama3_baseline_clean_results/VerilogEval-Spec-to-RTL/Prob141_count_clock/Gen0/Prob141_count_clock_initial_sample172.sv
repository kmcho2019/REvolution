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

assign hh = (hours == 0) ? 8'b00010010 : {4'b0000, hours};
assign mm = {4'b0000, minutes};
assign ss = {4'b0000, seconds};
assign pm = (hours[3] == 1) ? 1'b1 : 1'b0;

always @(posedge clk) begin
    if (reset) begin
        seconds <= 0;
        minutes <= 0;
        hours <= 0;
    end else if (ena) begin
        if (seconds == 9'd59) begin
            seconds <= 0;
            if (minutes == 9'd59) begin
                minutes <= 0;
                if (hours == 4'd12) begin
                    hours <= 1;
                end else if (hours == 4'd13) begin
                    hours <= 12;
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