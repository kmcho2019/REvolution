module TopModule(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

// Define the width of the counters
localparam HOURS_WIDTH = 5;
localparam MINUTES_WIDTH = 6;
localparam SECONDS_WIDTH = 6;

// Define the counters
reg [HOURS_WIDTH-1:0] hours;
reg [MINUTES_WIDTH-1:0] minutes;
reg [SECONDS_WIDTH-1:0] seconds;

// Define the am/pm indicator
reg pm_reg;

// Initialize the counters
initial begin
    hours = 0;
    minutes = 0;
    seconds = 0;
    pm_reg = 0;
end

// Update the counters on the positive edge of the clock
always @(posedge clk) begin
    // Reset the counters if reset is high
    if (reset) begin
        hours <= 0;
        minutes <= 0;
        seconds <= 0;
        pm_reg <= 0;
    // Increment the counters if enable is high
    end else if (ena) begin
        // Increment the seconds counter
        if (seconds == 59) begin
            seconds <= 0;
            // Increment the minutes counter
            if (minutes == 59) begin
                minutes <= 0;
                // Increment the hours counter
                if (hours == 11) begin
                    hours <= 0;
                    // Toggle the am/pm indicator
                    pm_reg <= ~pm_reg;
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

// Assign the outputs
assign pm = pm_reg;
assign hh = {4'd1, hours[3:0]};
assign mm = {2'd0, minutes[5:0]};
assign ss = {2'd0, seconds[5:0]};

endmodule