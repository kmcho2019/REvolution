// Define the module for handling hours
module HoursModule(
    input clk,
    input reset,
    input ena,
    output reg [3:0] hours,
    output reg pm
);

reg [3:0] hour_counter = 4'b0001; // Start at 1 (01 in BCD)
reg pm_flag = 1'b0;

always @(posedge clk) begin
    if (reset) begin
        hour_counter <= 4'b0001; // Reset hours to 1 (01 in BCD)
        pm_flag <= 1'b0;
    end else if (ena) begin
        if (hour_counter == 4'b1000) begin // 12 in BCD
            hour_counter <= 4'b0001; // Wrap around to 1 (01 in BCD)
            pm_flag <= ~pm_flag; // Toggle AM/PM
        end else begin
            hour_counter <= hour_counter + 1;
        end
    end
end

assign hours = hour_counter;
assign pm = pm_flag;

endmodule

// Define the module for handling minutes
module MinutesModule(
    input clk,
    input reset,
    input ena,
    output reg [5:0] minutes
);

reg [5:0] minute_counter = 6'b000000; // Start at 0 (00 in BCD)

always @(posedge clk) begin
    if (reset) begin
        minute_counter <= 6'b000000; // Reset minutes to 0 (00 in BCD)
    end else if (ena) begin
        if (minute_counter == 6'b010011) begin // 59 in BCD
            minute_counter <= 6'b000000; // Reset to 0 (00 in BCD)
        end else begin
            minute_counter <= minute_counter + 1;
        end
    end
end

assign minutes = minute_counter;

endmodule

// Define the module for handling seconds
module SecondsModule(
    input clk,
    input reset,
    input ena,
    output reg [5:0] seconds
);

reg [5:0] second_counter = 6'b000000; // Start at 0 (00 in BCD)

always @(posedge clk) begin
    if (reset) begin
        second_counter <= 6'b000000; // Reset seconds to 0 (00 in BCD)
    end else if (ena) begin
        if (second_counter == 6'b010011) begin // 59 in BCD
            second_counter <= 6'b000000; // Reset to 0 (00 in BCD)
        end else begin
            second_counter <= second_counter + 1;
        end
    end
end

assign seconds = second_counter;

endmodule

// TopModule: Controller for the clock
module TopModule(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

wire [3:0] hours;
wire [5:0] minutes;
wire [5:0] seconds;
wire pm_flag;

HoursModule hours_module(clk, reset, ena, hours, pm_flag);
MinutesModule minutes_module(clk, reset, ena, minutes);
SecondsModule seconds_module(clk, reset, ena, seconds);

assign pm = pm_flag;
assign hh = {hours[3], hours[2], hours[1], hours[0], 4'b0000};
assign mm = {minutes[5], minutes[4], minutes[3], minutes[2], minutes[1], minutes[0], 2'b00};
assign ss = {seconds[5], seconds[4], seconds[3], seconds[2], seconds[1], seconds[0], 2'b00};

endmodule