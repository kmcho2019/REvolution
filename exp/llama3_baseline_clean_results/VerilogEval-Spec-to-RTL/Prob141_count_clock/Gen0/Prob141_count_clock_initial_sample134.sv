module TopModule (
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

always @(posedge clk) begin
    if (reset) begin
        hours <= 8'h12;  // 12 in BCD
        minutes <= 8'h00;
        seconds <= 8'h00;
    end else if (ena) begin
        seconds <= seconds + 1;
        if (seconds == 8'h59) begin
            seconds <= 8'h00;
            minutes <= minutes + 1;
            if (minutes == 8'h59) begin
                minutes <= 8'h00;
                hours <= hours + 1;
                if (hours == 8'h12 + 8'h12) begin
                    hours <= 8'h01;  // wrap around to 1 o'clock
                end
            end
        end
    end
end

assign pm = (hours[3] == 1'b1);  // check the most significant bit of the hours
assign hh = hours;
assign mm = minutes;
assign ss = seconds;

endmodule