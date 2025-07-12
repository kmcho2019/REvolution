module TopModule(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

reg [4:0] sec; // internal seconds counter (0-59)
reg [5:0] min; // internal minutes counter (0-59)
reg [4:0] hour; // internal hours counter (0-23)

assign pm = (hour > 11); // pm if hour is between 12 and 23
assign hh = (hour < 12) ? {1'b0, hour[3:0]} : (hour == 12) ? 8'h12 : {1'b0, hour[3:0] - 12}; // convert to 12-hour format
assign mm = {1'b0, min[5:0]}; // minutes in BCD format
assign ss = {1'b0, sec[4:0]}; // seconds in BCD format

always @(posedge clk) begin
    if (reset) begin // reset to "12:00 AM"
        sec <= 0;
        min <= 0;
        hour <= 0;
    end else if (ena) begin // increment clock
        if (sec == 59) begin
            sec <= 0;
            if (min == 59) begin
                min <= 0;
                if (hour == 23) begin
                    hour <= 0;
                end else begin
                    hour <= hour + 1;
                end
            end else begin
                min <= min + 1;
            end
        end else begin
            sec <= sec + 1;
        end
    end
end

endmodule