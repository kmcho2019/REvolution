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

always @(posedge clk) begin
    if (reset) begin
        seconds <= 4'b0000;
        minutes <= 4'b0000;
        hours <= 4'b0001;
    end else if (ena) begin
        if (seconds == 4'b0101) begin // 60 in BCD
            seconds <= 4'b0000;
            if (minutes == 4'b0101) begin // 60 in BCD
                minutes <= 4'b0000;
                if (hours == 4'b0100) begin // 12 in BCD
                    hours <= 4'b0001; // wrap around to 1
                end else begin
                    hours <= hours + 1'b1;
                end
            end else begin
                minutes <= minutes + 1'b1;
            end
        end else begin
            seconds <= seconds + 1'b1;
        end
    end
end

assign hh = {hours, 4'b0000};
assign mm = {minutes, 4'b0000};
assign ss = {seconds, 4'b0000};
assign pm = (hours[3] == 1'b1); // if hours is greater than or equal to 12

endmodule