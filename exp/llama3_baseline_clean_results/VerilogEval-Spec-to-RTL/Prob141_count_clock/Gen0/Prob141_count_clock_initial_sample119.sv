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

always @(posedge clk) begin
    if (reset) begin
        hours <= 8'b0001_0010; // 12 in BCD
        minutes <= 8'b0000_0000; // 0 in BCD
        seconds <= 8'b0000_0000; // 0 in BCD
    end else if (ena) begin
        if (seconds == 8'b0000_0101) begin // 59 in BCD
            seconds <= 8'b0000_0000; // 0 in BCD
            if (minutes == 8'b0000_1001) begin // 59 in BCD
                minutes <= 8'b0000_0000; // 0 in BCD
                if (hours == 8'b0001_0010) begin // 12 in BCD
                    hours <= 8'b0001_0001; // 1 in BCD
                end else if (hours == 8'b0001_0100) begin // AM/PM transition
                    hours <= 8'b0001_0001; // 1 in BCD
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

assign hh = hours;
assign mm = minutes;
assign ss = seconds;

assign pm = (hours > 8'b0001_0001 && hours < 8'b0001_0100) ? 1'b1 : 1'b0;

endmodule