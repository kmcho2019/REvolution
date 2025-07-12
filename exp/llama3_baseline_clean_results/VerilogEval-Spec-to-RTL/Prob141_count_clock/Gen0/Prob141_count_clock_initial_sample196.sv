module TopModule(
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

always @(posedge clk) begin
    if (reset) begin
        seconds <= 0;
        minutes <= 0;
        hours <= 0;
    end else if (ena) begin
        if (seconds == 59) begin
            seconds <= 0;
            if (minutes == 59) begin
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

always @(*) begin
    if (hours > 11) begin
        pm = 1'b1;
    end else begin
        pm = 1'b0;
    end
end

always @(*) begin
    // Convert hours to BCD
    hh = {1'b0, hours[3:0]};
    mm = {1'b0, minutes[5:0]};
    ss = {1'b0, seconds[5:0]};
end

endmodule