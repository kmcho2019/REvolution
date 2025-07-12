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
            if (seconds == 9'd59) begin
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
        end else if (ena_seconds && (minutes == 59)) begin
            minutes <= 0;
        end else if (ena_seconds && (minutes < 59)) begin
            minutes <= minutes + 1;
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
    always @(posedge clk) begin
        if (reset) begin
            hours <= 4'd12; // 12:00:00 AM
            pm_flag <= 0;
        end else if (ena_minutes) begin
            if (hours == 4'd11 && pm_flag == 0) begin
                hours <= 4'd12;
                pm_flag <= 1;
            end else if (hours == 4'd11 && pm_flag == 1) begin
                hours <= 4'd1;
            end else if (hours < 4'd11) begin
                hours <= hours + 1;
            end
        end
    end
endmodule

// Define a function for binary to BCD conversion
function [7:0] binary_to_bcd;
    input [5:0] binary;
    reg [7:0] bcd;
    reg [3:0] tens;
    reg [3:0] units;
    
    tens = binary / 10;
    units = binary % 10;
    
    bcd = {4'd0, tens, units};
    binary_to_bcd = bcd;
endfunction

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
reg [3:0] seconds;
reg [5:0] minutes;
reg [3:0] hours;
reg pm_flag;

Seconds seconds_mod(clk, reset, ena, seconds);
Minutes minutes_mod(clk, reset, (seconds == 9'd59), minutes);
Hours hours_mod(clk, reset, (minutes == 59), hours, pm_flag);

// Assign outputs
assign pm = pm_flag;
assign hh = binary_to_bcd({2'd0, hours});
assign mm = binary_to_bcd(minutes);
assign ss = binary_to_bcd({2'd0, seconds});

endmodule