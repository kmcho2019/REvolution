module TopModule(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

reg [31:0] total_seconds;
reg [4:0] hours;
reg [5:0] minutes;
reg [5:0] seconds;

always @(posedge clk) begin
    if (reset) begin
        total_seconds <= 0;
        hours <= 12;
        minutes <= 0;
        seconds <= 0;
        pm <= 1'b0; // Reset to AM
    end else if (ena) begin
        if (total_seconds == 43200) begin
            total_seconds <= 0; // Wrap around after 12 hours
        end else begin
            total_seconds <= total_seconds + 1;
        end

        hours <= total_seconds / 3600 % 12;
        minutes <= (total_seconds / 60) % 60;
        seconds <= total_seconds % 60;

        if (hours == 0) begin
            hours <= 12; // 12-hour clock
            pm <= 1'b0; // AM
        end else if (hours > 12) begin
            pm <= 1'b1; // PM
        end else begin
            pm <= 1'b0; // AM
        end

        // Convert hours, minutes, and seconds to BCD
        reg [3:0] hours_tens = hours / 10;
        reg [3:0] hours_ones = hours % 10;
        reg [3:0] minutes_tens = minutes / 10;
        reg [3:0] minutes_ones = minutes % 10;
        reg [3:0] seconds_tens = seconds / 10;
        reg [3:0] seconds_ones = seconds % 10;

        hh <= {hours_tens, hours_ones};
        mm <= {minutes_tens, minutes_ones};
        ss <= {seconds_tens, seconds_ones};
    end
end

endmodule