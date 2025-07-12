module TopModule(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

// Separate modules for seconds, minutes, and hours counters
wire [5:0] seconds;
wire [5:0] minutes;
wire [4:0] hours;

// Instantiation of counter modules
SecondsCounter seconds_counter(
    .clk(clk),
    .reset(reset),
    .ena(ena),
    .seconds_out(seconds)
);

MinutesCounter minutes_counter(
    .clk(clk),
    .reset(reset),
    .seconds(seconds),
    .minutes_out(minutes)
);

HoursCounter hours_counter(
    .clk(clk),
    .reset(reset),
    .minutes(minutes),
    .hours_out(hours)
);

// Generation of pm signal
always @(posedge clk) begin
    if (reset) begin
        pm <= 1'b0;
    end else if (hours >= 6 && hours <= 11) begin
        pm <= 1'b1;
    end else begin
        pm <= 1'b0;
    end
end

// BCD conversion for output signals
assign hh = (hours < 10)? {4'h0, hours} : {4'h1, hours[3:0]};
assign mm = (minutes < 10)? {4'h0, minutes} : {4'h1, minutes[3:0]};
assign ss = (seconds < 10)? {4'h0, seconds} : {4'h1, seconds[3:0]};

endmodule

// Separate module for seconds counter
module SecondsCounter(
    input clk,
    input reset,
    input ena,
    output reg [5:0] seconds_out
);

always @(posedge clk) begin
    if (reset) begin
        seconds_out <= 0;
    end else if (ena) begin
        if (seconds_out == 59) begin
            seconds_out <= 0;
        end else begin
            seconds_out <= seconds_out + 1;
        end
    end
end

endmodule

// Separate module for minutes counter
module MinutesCounter(
    input clk,
    input reset,
    input [5:0] seconds,
    output reg [5:0] minutes_out
);

always @(posedge clk) begin
    if (reset) begin
        minutes_out <= 0;
    end else if (seconds == 0) begin
        if (minutes_out == 59) begin
            minutes_out <= 0;
        end else begin
            minutes_out <= minutes_out + 1;
        end
    end
end

endmodule

// Separate module for hours counter
module HoursCounter(
    input clk,
    input reset,
    input [5:0] minutes,
    output reg [4:0] hours_out
);

always @(posedge clk) begin
    if (reset) begin
        hours_out <= 1; // Initialize to 1 for 12:00 AM
    end else if (minutes == 0) begin
        if (hours_out == 11) begin
            hours_out <= 1; // Wrap around to 1 for 1 PM
        end else begin
            hours_out <= hours_out + 1;
        end
    end
end

endmodule