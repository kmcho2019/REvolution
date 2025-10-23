// Define a module for seconds counter
module Seconds (
    input clk,
    input reset,
    input ena,
    output reg [5:0] seconds
);
    always_ff @(posedge clk) begin
        if (reset) begin
            seconds <= 0;
        end else if (ena) begin
            if (seconds == 59) begin
                seconds <= 0;
            end else begin
                seconds <= seconds + 1;
            end
        end
    end
endmodule

// Define a module for minutes counter
module Minutes (
    input clk,
    input reset,
    input ena_seconds, // Enable from seconds module
    output reg [5:0] minutes
);
    always_ff @(posedge clk) begin
        if (reset) begin
            minutes <= 0;
        end else if (ena_seconds) begin
            if (minutes == 59) begin
                minutes <= 0;
            end else begin
                minutes <= minutes + 1;
            end
        end
    end
endmodule

// Define a module for hours counter
module Hours (
    input clk,
    input reset,
    input ena_minutes, // Enable from minutes module
    output reg [3:0] hours,
    output reg pm_flag
);
    always_ff @(posedge clk) begin
        if (reset) begin
            hours <= 0; // 12:00:00 AM
            pm_flag <= 0;
        end else if (ena_minutes) begin
            if (hours == 11) begin
                hours <= 0;
                pm_flag <= ~pm_flag;
            end else begin
                hours <= hours + 1;
            end
        end
    end
endmodule

// Define the TopModule
module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

// Instantiate modules
reg [5:0] seconds;
reg [5:0] minutes;
reg [3:0] hours;
reg pm_flag;

Seconds seconds_mod(clk, reset, ena, seconds);
Minutes minutes_mod(clk, reset, (seconds == 59), minutes);
Hours hours_mod(clk, reset, (minutes == 59), hours, pm_flag);

// Assign outputs directly
assign pm = pm_flag;

// Explicitly convert binary to BCD for hours, minutes, and seconds
wire [3:0] hours_tens = hours / 10;
wire [3:0] hours_ones = hours % 10;
wire [3:0] minutes_tens = minutes / 10;
wire [3:0] minutes_ones = minutes % 10;
wire [3:0] seconds_tens = seconds / 10;
wire [3:0] seconds_ones = seconds % 10;

// Assign BCD values to output ports, ensuring correct widths
assign hh = {4'b0000, hours_tens, hours_ones};
assign mm = {4'b0000, minutes_tens, minutes_ones};
assign ss = {4'b0000, seconds_tens, seconds_ones};

endmodule