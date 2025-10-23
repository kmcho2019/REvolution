module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

reg [5:0] seconds;
reg [5:0] minutes;
reg [3:0] hours;
reg pm_flag;

// Define constants for better readability
localparam RESET_HOURS = 4'd0; // Hours reset to 12
localparam MAX_HOURS = 4'd11;
localparam MAX_MINUTES = 5'd59;
localparam MAX_SECONDS = 5'd59;

always_ff @(posedge clk) begin
    if (reset) begin
        seconds <= 0;
        minutes <= 0;
        hours <= RESET_HOURS;
        pm_flag <= 0; // AM
    end else if (ena) begin
        if (seconds == MAX_SECONDS) begin
            seconds <= 0;
            if (minutes == MAX_MINUTES) begin
                minutes <= 0;
                if (hours == MAX_HOURS) begin
                    hours <= 0;
                    pm_flag <= ~pm_flag; // Toggle AM/PM
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

// Explicitly convert binary to BCD for hours, minutes, and seconds
wire [3:0] hours_tens = (hours >= 5) ? (hours - 5) / 2 + 1 : hours / 2;
wire [3:0] hours_ones = (hours >= 5) ? (hours - 5) % 2 + 2 : hours % 2;
wire [3:0] minutes_tens = (minutes >= 10) ? minutes / 10 : 0;
wire [3:0] minutes_ones = (minutes >= 10) ? minutes % 10 : minutes;
wire [3:0] seconds_tens = (seconds >= 10) ? seconds / 10 : 0;
wire [3:0] seconds_ones = (seconds >= 10) ? seconds % 10 : seconds;

// Correctly assign hh, mm, ss considering BCD format
assign pm = pm_flag;
assign hh = {4'b0000, hours_tens, hours_ones};
assign mm = {4'b0000, minutes_tens, minutes_ones};
assign ss = {4'b0000, seconds_tens, seconds_ones};

endmodule