module TopModule(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

reg [3:0] hours_int;
reg [5:0] minutes_int;
reg [5:0] seconds_int;

always @(posedge clk) begin
    if (reset) begin
        hours_int <= 0;
        minutes_int <= 0;
        seconds_int <= 0;
    end else if (ena) begin
        if (seconds_int == 59) begin
            seconds_int <= 0;
            if (minutes_int == 59) begin
                minutes_int <= 0;
                if (hours_int == 11) begin
                    hours_int <= 0;
                end else begin
                    hours_int <= hours_int + 1;
                end
            end else begin
                minutes_int <= minutes_int + 1;
            end
        end else begin
            seconds_int <= seconds_int + 1;
        end
    end
end

always @(*) begin
    pm = (hours_int >= 6) ? 1'b1 : 1'b0;
    hh = {4'b0000, hours_int};
    if (hours_int == 0) begin
        hh = 8'h12; // Display 12 for 0 hours
    end
    mm = {4'b0000, minutes_int};
    ss = {4'b0000, seconds_int};
end

endmodule