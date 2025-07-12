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
        if (total_seconds == 43200) begin
            total_seconds <= 0; // Wrap around after 12 hours
        end else begin
            total_seconds <= total_seconds + 1;
        end
    end
end

always @(posedge clk) begin
    reg [4:0] hours;
    reg [5:0] minutes;
    reg [5:0] seconds;

    hours = total_seconds / 3600 % 12; // Calculate hours
    minutes = (total_seconds / 60) % 60; // Calculate minutes
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
    hh = {4'b0000, hours % 10[3:0]} + ({4'b0000, hours / 10[3:0]} << 4);
    mm = {4'b0000, minutes % 10[3:0]} + ({4'b0000, minutes / 10[3:0]} << 4);
    ss = {4'b0000, seconds % 10[3:0]} + ({4'b0000, seconds / 10[3:0]} << 4);
end

endmodule