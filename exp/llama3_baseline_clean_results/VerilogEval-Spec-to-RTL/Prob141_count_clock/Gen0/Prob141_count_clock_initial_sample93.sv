module TopModule(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

reg [3:0] sec;
reg [3:0] min;
reg [3:0] hour;

always @(posedge clk) begin
    if (reset) begin
        sec <= 0;
        min <= 0;
        hour <= 1;  // initial hour is 1 (01 in BCD)
    end
    else if (ena) begin
        if (sec == 9'd59) begin
            sec <= 0;
            if (min == 9'd59) begin
                min <= 0;
                if (hour == 9'd12) begin
                    hour <= 1;  // wrap around from 12 to 1
                end
                else begin
                    hour <= hour + 1;
                end
            end
            else begin
                min <= min + 1;
            end
        end
        else begin
            sec <= sec + 1;
        end
    end
end

always @(*) begin
    if (hour > 6) begin  // if hour is greater than 6, it's PM
        pm = 1'b1;
    end
    else begin
        pm = 1'b0;
    end

    hh = {4'b0000, hour};  // convert hour to 8-bit BCD
    mm = {4'b0000, min};  // convert min to 8-bit BCD
    ss = {4'b0000, sec};  // convert sec to 8-bit BCD
end

endmodule