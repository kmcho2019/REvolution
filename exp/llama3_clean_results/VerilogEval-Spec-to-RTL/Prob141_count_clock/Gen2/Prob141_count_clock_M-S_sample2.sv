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

assign hh = hours;
assign mm = minutes;
assign ss = seconds;

assign pm = (hours >= 8'h12) ? 1'b1 : 1'b0;

always @(posedge clk) begin
    if (reset) begin
        hours <= 8'h12;
        minutes <= 8'h00;
        seconds <= 8'h00;
    end else if (ena) begin
        if (seconds == 8'h59) begin
            seconds <= 8'h00;
            if (minutes == 8'h59) begin
                minutes <= 8'h00;
                if (hours == 8'h12) begin
                    hours <= 8'h01;
                end else if (hours == 8'h11) begin
                    hours <= 8'h12;
                end else begin
                    hours <= hours + 8'h01;
                end
            end else begin
                minutes <= minutes + 8'h01;
            end
        end else begin
            seconds <= seconds + 8'h01;
        end
    end
end

endmodule