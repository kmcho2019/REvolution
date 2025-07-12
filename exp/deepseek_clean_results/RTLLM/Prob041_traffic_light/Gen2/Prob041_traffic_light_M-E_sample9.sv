module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [7:0] clock,
    output red,
    output yellow,
    output green
);

// Time wheel parameters
parameter TOTAL_CYCLES = 75; // 60 green + 5 yellow + 10 red
parameter GREEN_START = 0;
parameter GREEN_END = 59;
parameter YELLOW_START = 60;
parameter YELLOW_END = 64;
parameter RED_START = 65;
parameter RED_END = 74;
parameter MIN_GREEN = 10; // Minimum green time when pedestrian requests

// Time wheel shift register
reg [TOTAL_CYCLES-1:0] time_wheel;
reg [7:0] position;
reg fast_forward;

// Output generation
wire is_green = (position >= GREEN_START) && (position <= GREEN_END);
wire is_yellow = (position >= YELLOW_START) && (position <= YELLOW_END);
wire is_red = (position >= RED_START) && (position <= RED_END);

assign red = is_red;
assign yellow = is_yellow;
assign green = is_green;
assign clock = position;

// Time wheel rotation logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Initialize time wheel with single '1' at position 0
        time_wheel <= {1'b1, {(TOTAL_CYCLES-1){1'b0}}};
        position <= GREEN_START;
        fast_forward <= 1'b0;
    end else begin
        // Handle pedestrian request
        if (pass_request && is_green && (position <= (GREEN_END - MIN_GREEN))) begin
            fast_forward <= 1'b1;
            position <= GREEN_END - MIN_GREEN + 1;
        end
        
        // Normal rotation or fast-forward
        if (fast_forward) begin
            if (position == GREEN_END) begin
                fast_forward <= 1'b0;
                time_wheel <= {1'b1, {(TOTAL_CYCLES-1){1'b0}}};
                position <= YELLOW_START;
            end else begin
                time_wheel <= time_wheel << 1;
                position <= position + 1;
            end
        end else begin
            time_wheel <= {time_wheel[TOTAL_CYCLES-2:0], time_wheel[TOTAL_CYCLES-1]};
            position <= (position == TOTAL_CYCLES-1) ? 0 : position + 1;
        end
    end
end

endmodule