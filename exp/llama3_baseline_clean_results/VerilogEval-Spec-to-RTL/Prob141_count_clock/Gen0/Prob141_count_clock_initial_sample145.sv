module TopModule(clk, reset, ena, pm, hh, mm, ss);
    input clk;
    input reset;
    input ena;
    output pm;
    output [7:0] hh;
    output [7:0] mm;
    output [7:0] ss;

    reg [3:0] hours;
    reg [5:0] minutes;
    reg [5:0] seconds;

    always @(posedge clk) begin
        if (reset) begin
            hours <= 0;
            minutes <= 0;
            seconds <= 0;
        end else if (ena) begin
            if (seconds == 60 - 1) begin
                seconds <= 0;
                if (minutes == 60 - 1) begin
                    minutes <= 0;
                    if (hours == 12) begin
                        hours <= 1;
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

    assign pm = (hours >= 12);
    assign hh = (hours == 0) ? 8'h12 : (hours > 12) ? hours - 12 : hours;
    assign mm = {1'b0, minutes[5:1], 1'b0, minutes[0]};
    assign ss = {1'b0, seconds[5:1], 1'b0, seconds[0]};

endmodule