module TopModule(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

// Internal signals
reg [3:0] hours; // Hours (0-11)
reg [5:0] minutes; // Minutes (0-59)
reg [5:0] seconds; // Seconds (0-59)

// Initialize counters
initial begin
    hours = 0;
    minutes = 0;
    seconds = 0;
end

// Sequential logic
always @(posedge clk) begin
    if (reset) begin
        // Reset counters to initial values
        hours <= 0;
        minutes <= 0;
        seconds <= 0;
    end else if (ena) begin
        // Increment seconds counter
        if (seconds == 59) begin
            seconds <= 0;
            // Increment minutes counter
            if (minutes == 59) begin
                minutes <= 0;
                // Increment hours counter
                if (hours == 11) begin
                    hours <= 0;
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

// Combinational logic
wire [3:0] hours_tens = hours / 10; // Tens place of hours
wire [3:0] hours_ones = hours % 10; // Ones place of hours
wire [3:0] minutes_tens = minutes / 10; // Tens place of minutes
wire [3:0] minutes_ones = minutes % 10; // Ones place of minutes
wire [3:0] seconds_tens = seconds / 10; // Tens place of seconds
wire [3:0] seconds_ones = seconds % 10; // Ones place of seconds

assign hh = {4'h0, hours_tens, 4'h0, hours_ones};
assign mm = {4'h0, minutes_tens, 4'h0, minutes_ones};
assign ss = {4'h0, seconds_tens, 4'h0, seconds_ones};

// PM indicator
assign pm = (hours >= 6 && hours < 12);

endmodule