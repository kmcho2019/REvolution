module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

// Define a module for seconds counter
module Seconds (
    input clk,
    input reset,
    input ena,
    output reg [3:0] seconds
);
    always @(posedge clk) begin
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
    always @(posedge clk) begin
        if (reset) begin
            minutes <= 0;
        end else if (ena_seconds && (minutes % 60 == 59)) begin
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
    output reg [4:0] hours,
    output reg pm_flag
);
    always @(posedge clk) begin
        if (reset) begin
            hours <= 12; // 12:00:00 AM
            pm_flag <= 0;
        end else if (ena_minutes && (hours % 12 == 11)) begin
            if (hours == 11) begin
                hours <= 12;
                pm_flag <= ~pm_flag;
            end else begin
                hours <= hours + 1;
            end
        end
    end
endmodule

// Instantiate modules
reg [3:0] seconds;
reg [5:0] minutes;
reg [4:0] hours;
reg pm_flag;

Seconds seconds_mod(clk, reset, ena, seconds);
Minutes minutes_mod(clk, reset, (seconds == 59), minutes);
Hours hours_mod(clk, reset, (minutes % 60 == 59), hours, pm_flag);

// Convert binary to BCD
function [7:0] binary_to_bcd;
    input [5:0] binary;
    reg [7:0] bcd;
    bcd = {4'b0000, binary / 10, binary % 10};
    binary_to_bcd = bcd;
endfunction

// Assign outputs
assign pm = pm_flag;
assign hh = binary_to_bcd(hours);
assign mm = binary_to_bcd(minutes);
assign ss = binary_to_bcd(seconds);

endmodule