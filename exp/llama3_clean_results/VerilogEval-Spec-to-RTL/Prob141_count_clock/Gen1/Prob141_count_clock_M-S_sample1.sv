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
reg [3:0] minutes; // Minutes (0-59)
reg [3:0] seconds; // Seconds (0-59)

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
        if (seconds == 9) begin
            seconds <= 0;
            // Increment minutes counter
            if (minutes == 5 && seconds == 0) begin
                minutes <= 0;
                // Increment hours counter
                if (hours == 11) begin
                    hours <= 0;
                end else begin
                    hours <= hours + 1;
                end
            end else if (minutes < 5) begin
                minutes <= minutes + 1;
            end
        end else begin
            seconds <= seconds + 1;
        end
    end
end

// Combinational logic
assign hh = (hours < 9)? {4'h0, hours, 4'h1, 4'h2} : {4'h1, hours - 9, 4'h0, 4'h2};
assign mm = (minutes < 10)? {4'h0, minutes, 4'h0, 4'h0} : {4'h0, minutes % 10, 4'h0, minutes / 10};
assign ss = (seconds < 10)? {4'h0, seconds, 4'h0, 4'h0} : {4'h0, seconds % 10, 4'h0, seconds / 10};

// PM indicator
assign pm = (hours >= 6 && hours < 12);

endmodule