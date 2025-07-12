module Counter #(
    parameter WIDTH = 4,
    parameter MAX_VALUE = 9
) (
    input clk,
    input reset,
    input ena,
    output reg [WIDTH-1:0] value
);

always @(posedge clk) begin
    if (reset) begin
        value <= 0;
    end else if (ena) begin
        if (value == MAX_VALUE) begin
            value <= 0;
        end else begin
            value <= value + 1;
        end
    end
end

endmodule

module HoursCounter (
    input clk,
    input reset,
    input ena,
    output reg [3:0] hours_tens,
    output reg [3:0] hours_units,
    output reg pm
);

reg [3:0] hours;
reg pm_flag;

Counter tens_counter (.clk(clk), .reset(reset), .ena(ena && hours_units == 9), .value(hours_tens));
Counter units_counter (.clk(clk), .reset(reset), .ena(ena), .value(hours_units));

always @(posedge clk) begin
    if (reset) begin
        hours_tens <= 1; // 1 in BCD
        hours_units <= 2; // 2 in BCD
        pm_flag <= 1'b0;
    end else if (ena && hours_units == 9 && hours_tens == 2) begin // 12 PM
        hours_tens <= 1;
        hours_units <= 1;
        pm_flag <= ~pm_flag;
    end
end

assign pm = pm_flag;

endmodule

module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

reg [3:0] minutes_tens;
reg [3:0] minutes_units;
reg [3:0] seconds_tens;
reg [3:0] seconds_units;

HoursCounter hours_counter (.clk(clk), .reset(reset), .ena(ena), .hours_tens(), .hours_units(), .pm(pm));
Counter minutes_tens_counter (.clk(clk), .reset(reset), .ena(ena && minutes_units == 9), .value(minutes_tens));
Counter minutes_units_counter (.clk(clk), .reset(reset), .ena(ena), .value(minutes_units));
Counter seconds_tens_counter (.clk(clk), .reset(reset), .ena(ena && seconds_units == 9), .value(seconds_tens));
Counter seconds_units_counter (.clk(clk), .reset(reset), .ena(ena), .value(seconds_units));

assign hh = {hours_counter.hours_tens, hours_counter.hours_units, 4'b0000};
assign mm = {minutes_tens, minutes_units, 4'b0000};
assign ss = {seconds_tens, seconds_units, 4'b0000};

endmodule