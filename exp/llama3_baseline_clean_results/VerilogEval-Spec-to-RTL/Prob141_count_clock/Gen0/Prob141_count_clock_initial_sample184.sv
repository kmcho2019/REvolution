module TopModule(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

reg [7:0] seconds;
reg [7:0] minutes;
reg [7:0] hours;

always @(posedge clk) begin
    if (reset) begin
        seconds <= 8'b00000000; // 00
        minutes <= 8'b00000000; // 00
        hours <= 8'b00010010;   // 12
        pm <= 1'b0;             // AM
    end else if (ena) begin
        if (seconds == 8'b00111011) begin // 59
            seconds <= 8'b00000000; // 00
            if (minutes == 8'b00111011) begin // 59
                minutes <= 8'b00000000; // 00
                if (hours == 8'b00010010) begin // 12 AM
                    hours <= 8'b00010010; // 12
                    pm <= 1'b1;           // PM
                end else if (hours == 8'b00010100) begin // 12 PM
                    hours <= 8'b00000001; // 1
                    pm <= 1'b0;           // AM
                end else begin
                    hours <= hours + 1;
                    if (hours[3] == 1'b1) // check if greater than 12
                        pm <= ~pm;
                end
            end else begin
                minutes <= minutes + 1;
            end
        end else begin
            seconds <= seconds + 1;
        end
    end
end

always @(posedge clk) begin
    hh <= hours;
    mm <= minutes;
    ss <= seconds;
end

endmodule