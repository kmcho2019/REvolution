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
        seconds <= 4'b0;
        minutes <= 4'b0;
        hours <= 4'b1;
    end else if (ena) begin
        if (seconds == 4'd59) begin
            seconds <= 4'b0;
            if (minutes == 4'd59) begin
                minutes <= 4'b0;
                if (hours == 4'd11) begin
                    hours <= 4'b1;
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

assign pm = hours[3];

assign hh = {hours[3], hours};

assign mm = {minutes[3], minutes};

assign ss = {seconds[3], seconds};

endmodule