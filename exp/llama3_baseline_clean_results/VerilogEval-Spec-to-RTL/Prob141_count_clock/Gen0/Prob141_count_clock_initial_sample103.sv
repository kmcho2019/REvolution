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
        hours <= 8'b00010001; // 12 in BCD
        minutes <= 8'b00000000; // 00 in BCD
        seconds <= 8'b00000000; // 00 in BCD
    end else if (ena) begin
        if (seconds == 8'b00010010) begin // 60 in BCD
            seconds <= 8'b00000000; // 00 in BCD
            if (minutes == 8'b00100100) begin // 60 in BCD
                minutes <= 8'b00000000; // 00 in BCD
                if (hours == 8'b00010010) begin // 12 in BCD (PM to AM)
                    hours <= 8'b00010001; // 01 in BCD
                end else if (hours == 8'b00010001) begin // 01 in BCD (AM to PM)
                    hours <= 8'b00010010; // 12 in BCD
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
    if (hours >= 8'b00010010) begin // 12 in BCD
        pm <= 1'b1;
    end else begin
        pm <= 1'b0;
    end
end

assign hh = hours;
assign mm = minutes;
assign ss = seconds;

endmodule