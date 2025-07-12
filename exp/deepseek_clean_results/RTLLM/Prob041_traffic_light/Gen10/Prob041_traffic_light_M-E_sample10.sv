module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [5:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

// Timing parameters
parameter GREEN_TIME = 6'd60;
parameter YELLOW_TIME = 6'd5;
parameter RED_TIME = 6'd10;
parameter PEDESTRIAN_MIN_GREEN = 6'd10;

// Counters for each light
reg [5:0] red_cnt;
reg [5:0] yellow_cnt;
reg [5:0] green_cnt;

// Counter expiration signals
wire red_expired = (red_cnt == 0);
wire yellow_expired = (yellow_cnt == 0);
wire green_expired = (green_cnt == 0);

// Pedestrian request handling
wire pedestrian_active = pass_request && !green_expired && (green_cnt > PEDESTRIAN_MIN_GREEN);

// Output the currently active counter value
assign clock = !red_expired ? red_cnt : 
               !yellow_expired ? yellow_cnt : 
               green_cnt;

// Light activation logic
always @(*) begin
    red = !red_expired;
    yellow = red_expired && !yellow_expired;
    green = red_expired && yellow_expired && !green_expired;
end

// Counter management
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        red_cnt <= RED_TIME;
        yellow_cnt <= 0;
        green_cnt <= 0;
    end else begin
        // Handle pedestrian request
        if (pedestrian_active) begin
            green_cnt <= PEDESTRIAN_MIN_GREEN;
        end
        
        // Normal counter updates
        if (!red_expired) begin
            red_cnt <= red_cnt - 1;
            if (red_expired) begin
                green_cnt <= GREEN_TIME;
            end
        end 
        else if (!yellow_expired) begin
            yellow_cnt <= yellow_cnt - 1;
            if (yellow_expired) begin
                red_cnt <= RED_TIME;
            end
        end 
        else if (!green_expired) begin
            green_cnt <= green_cnt - 1;
            if (green_expired) begin
                yellow_cnt <= YELLOW_TIME;
            end
        end
    end
end

endmodule