module TopModule(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

reg [3:0] hours;
reg [5:0] minutes;
reg [5:0] seconds;

always @(posedge clk) begin
    if (reset) begin
        hours <= 4'b1001; // Reset hours to 01 (1 in BCD)
        minutes <= 6'b000000; // Reset minutes to 00 (0 in BCD)
        seconds <= 6'b000000; // Reset seconds to 00 (0 in BCD)
        pm <= 1'b0; // Reset to AM
    end else if (ena) begin
        if (seconds == 6'b010011) begin // 59 in BCD
            seconds <= 6'b000000; // Wrap seconds to 00 (0 in BCD)
            if (minutes == 6'b010011) begin // 59 in BCD
                minutes <= 6'b000000; // Wrap minutes to 00 (0 in BCD)
                if (hours == 4'b1000) begin // 12 in BCD
                    hours <= 4'b1001; // Wrap hours to 01 (1 in BCD)
                    pm <= ~pm; // Toggle AM/PM
                end else begin
                    hours <= hours + 1; // Increment hours
                end
            end else begin
                minutes <= minutes + 1; // Increment minutes
            end
        end else begin
            seconds <= seconds + 1; // Increment seconds
        end
    end
end

assign hh = {4'b0000, hours}; // Drive hh from hours
assign mm = {2'b00, minutes}; // Drive mm from minutes
assign ss = {2'b00, seconds}; // Drive ss from seconds

endmodule