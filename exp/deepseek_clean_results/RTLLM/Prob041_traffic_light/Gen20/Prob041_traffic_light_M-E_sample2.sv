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
parameter GREEN_TIME = 60;
parameter YELLOW_TIME = 5;
parameter RED_TIME = 10;
parameter MIN_GREEN = 10;

// Gray-coded state encoding
localparam [1:0] 
    IDLE  = 2'b00,
    RED   = 2'b01,
    YELLOW = 2'b11,
    GREEN = 2'b10;

reg [1:0] state, next_state;
reg [5:0] cnt;
reg [5:0] shadow_cnt; // Shadow counter for green time adjustment
reg [5:0] next_cnt;   // Predictive next counter value

// Main state machine
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        cnt <= RED_TIME;
        shadow_cnt <= GREEN_TIME;
    end else begin
        state <= next_state;
        cnt <= next_cnt;
        
        // Update shadow counter only during green phase
        if (state == GREEN) begin
            if (pass_request && (shadow_cnt > MIN_GREEN))
                shadow_cnt <= MIN_GREEN;
            else
                shadow_cnt <= shadow_cnt - 1;
        end else begin
            shadow_cnt <= GREEN_TIME;
        end
    end
end

// Priority-based next state logic
always @(*) begin
    // Default outputs
    red = 1'b0;
    yellow = 1'b0;
    green = 1'b0;
    next_state = state;
    next_cnt = cnt - 1;
    
    case (state)
        IDLE: begin
            next_state = RED;
            next_cnt = RED_TIME;
        end
        
        RED: begin
            red = 1'b1;
            if (cnt == 1) begin
                next_state = GREEN;
                next_cnt = shadow_cnt; // Use shadow counter value
            end
        end
        
        YELLOW: begin
            yellow = 1'b1;
            if (cnt == 1) begin
                next_state = RED;
                next_cnt = RED_TIME;
            end
        end
        
        GREEN: begin
            green = 1'b1;
            if (cnt == 1) begin
                next_state = YELLOW;
                next_cnt = YELLOW_TIME;
            end
            // Immediate response to pedestrian request
            if (pass_request && (cnt > MIN_GREEN))
                next_cnt = MIN_GREEN;
        end
    endcase
end

assign clock = cnt;

endmodule