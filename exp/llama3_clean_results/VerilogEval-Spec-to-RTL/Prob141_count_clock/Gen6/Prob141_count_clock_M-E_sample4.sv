module TopModule(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

// Define the width of the counters
localparam HOURS_WIDTH = 4;
localparam MINUTES_SECONDS_WIDTH = 6;

// Define the states for the counters
localparam STATE_RESET = 0;
localparam STATE_IDLE = 1;
localparam STATE_INCREMENT = 2;

// Define the counters
reg [HOURS_WIDTH-1:0] hours;
reg [MINUTES_SECONDS_WIDTH-1:0] minutes;
reg [MINUTES_SECONDS_WIDTH-1:0] seconds;

// Define the control unit state
reg [1:0] state;

// Define the AM/PM flag
reg pm_flag;

// Initialize the counters and control unit state
initial begin
    hours = 4'b0001; // Initial hours in BCD (01)
    minutes = 6'b000000; // Initial minutes in BCD (00)
    seconds = 6'b000000; // Initial seconds in BCD (00)
    state = STATE_RESET;
    pm_flag = 1'b0; // Initial AM/PM flag (AM)
end

// Define the control unit logic
always @(posedge clk) begin
    case (state)
        STATE_RESET: begin
            if (!reset) begin
                state <= STATE_IDLE;
            end else begin
                hours <= 4'b0001; // Reset hours to 01 (1 in BCD)
                minutes <= 6'b000000; // Reset minutes to 00 (0 in BCD)
                seconds <= 6'b000000; // Reset seconds to 00 (0 in BCD)
                pm_flag <= 1'b0; // Reset to AM
            end
        end
        STATE_IDLE: begin
            if (ena) begin
                state <= STATE_INCREMENT;
            end
        end
        STATE_INCREMENT: begin
            // Increment seconds
            if (seconds == 6'b010011) begin // 59 in BCD
                seconds <= 6'b000000; // Reset seconds to 00 (0 in BCD)
                // Increment minutes
                if (minutes == 6'b010011) begin // 59 in BCD
                    minutes <= 6'b000000; // Reset minutes to 00 (0 in BCD)
                    // Increment hours
                    if (hours == 4'b1000) begin // 12 in BCD
                        hours <= 4'b0001; // Wrap hours to 01 (1 in BCD)
                        pm_flag <= ~pm_flag; // Toggle AM/PM
                    end else begin
                        hours <= hours + 1; // Increment hours
                    end
                end else begin
                    minutes <= minutes + 1; // Increment minutes
                end
            end else begin
                seconds <= seconds + 1; // Increment seconds
            end
            state <= STATE_IDLE;
        end
    endcase
end

// Assign the output signals
assign pm = pm_flag;
assign hh = {hours[3], hours[2], hours[1], hours[0], 4'b0000};
assign mm = {minutes[5], minutes[4], minutes[3], minutes[2], minutes[1], minutes[0], 2'b00};
assign ss = {seconds[5], seconds[4], seconds[3], seconds[2], seconds[1], seconds[0], 2'b00};

endmodule