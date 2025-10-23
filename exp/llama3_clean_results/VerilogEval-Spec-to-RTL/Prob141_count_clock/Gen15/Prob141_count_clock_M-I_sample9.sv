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

    hours = total_seconds / 3600 % 12; // Calculate hours (0-11)
    minutes = (total_seconds / 60) % 60; // Calculate minutes (0-59)
    seconds = total_seconds % 60; // Calculate seconds (0-59)

    if (hours == 0) begin
        hours = 12; // 12-hour clock
        pm = 1'b0; // AM
    end else if (hours >= 12) begin
        pm = 1'b1; // PM
    end else begin
        pm = 1'b0; // AM
    end

    // Convert hours, minutes, and seconds to BCD
    hh[3:0] = hours % 10;
    hh[7:4] = hours / 10;
    mm[3:0] = minutes % 10;
    mm[7:4] = minutes / 10;
    ss[3:0] = seconds % 10;
    ss[7:4] = seconds / 10;
end

endmodule