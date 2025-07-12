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

always @(posedge clk) begin
    if (reset) begin
        total_seconds <= 0;
        pm <= 1'b0; // Reset to AM
    end else if (ena) begin
        total_seconds <= total_seconds + 1;
    end
end

always @(posedge clk) begin
    reg [4:0] hours;
    reg [5:0] minutes;
    reg [5:0] seconds;

    hours = total_seconds / 3600 % 12; // Calculate hours
    minutes = total_seconds / 60 % 60; // Calculate minutes
    seconds = total_seconds % 60; // Calculate seconds

    if (hours == 0) begin
        hours = 12; // 12-hour clock
        pm = 1'b0; // AM
    end else if (hours > 6) begin
        pm = 1'b1; // PM
    end else begin
        pm = 1'b0; // AM
    end

    // Convert hours, minutes, and seconds to BCD
    hh = {4'b0000, hours % 10} + (hours / 10) * 16;
    mm = {2'b00, minutes % 10} + (minutes / 10) * 16;
    ss = {2'b00, seconds % 10} + (seconds / 10) * 16;
end

endmodule