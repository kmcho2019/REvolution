module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [7:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

// Timing parameters
parameter GREEN_TIME  = 60;
parameter YELLOW_TIME = 5;
parameter RED_TIME    = 10;
parameter MIN_GREEN   = 10;

// Parallel counters
reg [7:0] green_counter;
reg [7:0] yellow_counter;
reg [7:0] red_counter;

// Time bank for green extension
reg [7:0] green_bank;

// Watchdog timers
reg [3:0] min_green_watchdog;
reg [1:0] min_yellow_watchdog;

// Output the active counter
assign clock = (green) ? green_counter : 
               (yellow) ? yellow_counter : red_counter;

// Parallel counter update
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        green_counter  <= GREEN_TIME;
        yellow_counter <= YELLOW_TIME;
        red_counter   <= RED_TIME;
        green_bank     <= 0;
        min_green_watchdog <= 0;
        min_yellow_watchdog <= 0;
    end else begin
        // Decrement all counters in parallel
        if (green_counter > 0) green_counter <= green_counter - 1;
        if (yellow_counter > 0) yellow_counter <= yellow_counter - 1;
        if (red_counter > 0) red_counter <= red_counter - 1;

        // Handle pedestrian request
        if (pass_request && green && (green_counter > MIN_GREEN)) begin
            green_bank <= green_bank + (green_counter - MIN_GREEN);
            green_counter <= MIN_GREEN;
        end

        // Watchdog for minimum durations
        if (green) begin
            min_green_watchdog <= (min_green_watchdog < MIN_GREEN) ? 
                                 min_green_watchdog + 1 : MIN_GREEN;
        end else begin
            min_green_watchdog <= 0;
        end

        if (yellow) begin
            min_yellow_watchdog <= min_yellow_watchdog + 1;
        end else begin
            min_yellow_watchdog <= 0;
        end
    end
end

// State determination (priority: red > yellow > green)
always @(*) begin
    red = 0; yellow = 0; green = 0;
    
    if (red_counter == 0 || 
        (yellow_counter == 0 && min_yellow_watchdog >= 2) ||
        (green_counter == 0 && min_green_watchdog >= MIN_GREEN)) begin
        // Priority to red if any counter expired
        red = 1;
    end else if (yellow_counter == 0 || 
               (green_counter == 0 && min_green_watchdog < MIN_GREEN)) begin
        // Then yellow
        yellow = 1;
    end else begin
        // Default to green
        green = 1;
    end
end

// Counter reload logic
always @(posedge clk) begin
    // Reload counters when they reach zero
    if (green_counter == 0) begin
        green_counter <= GREEN_TIME + green_bank;
        green_bank <= 0;
    end
    if (yellow_counter == 0) yellow_counter <= YELLOW_TIME;
    if (red_counter == 0) red_counter <= RED_TIME;
end

endmodule