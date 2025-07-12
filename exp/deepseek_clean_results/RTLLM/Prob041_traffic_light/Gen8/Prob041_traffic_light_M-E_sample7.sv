module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [7:0] clock,
    output red,
    output yellow,
    output green
);

// Timing parameters
parameter GREEN_NORMAL = 60;
parameter YELLOW_NORMAL = 5;
parameter RED_NORMAL = 10;
parameter GREEN_MIN = 10;

// State encoding
typedef enum {S_IDLE, S_RED, S_YELLOW, S_GREEN} state_t;
state_t current_state, next_state;

// Timer module
reg [7:0] timer;
reg timer_load;
reg [7:0] timer_value;
wire timer_expired = (timer == 1);

// State outputs
assign red = (current_state == S_RED);
assign yellow = (current_state == S_YELLOW);
assign green = (current_state == S_GREEN);
assign clock = timer;

// Timer management
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        timer <= RED_NORMAL;
    end else if (timer_load) begin
        timer <= timer_value;
    end else if (!timer_expired) begin
        timer <= timer - 1;
    end
end

// State transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= S_IDLE;
    end else begin
        current_state <= next_state;
    end
end

// Next state and timer control
always @(*) begin
    // Default values
    next_state = current_state;
    timer_load = 1'b0;
    timer_value = RED_NORMAL;
    
    case (current_state)
        S_IDLE: begin
            next_state = S_RED;
            timer_load = 1'b1;
            timer_value = RED_NORMAL;
        end
        
        S_RED: begin
            if (timer_expired) begin
                next_state = S_GREEN;
                timer_load = 1'b1;
                timer_value = GREEN_NORMAL;
            end
        end
        
        S_YELLOW: begin
            if (timer_expired) begin
                next_state = S_RED;
                timer_load = 1'b1;
                timer_value = RED_NORMAL;
            end
        end
        
        S_GREEN: begin
            // Handle pedestrian request
            if (pass_request && (timer > GREEN_MIN)) begin
                timer_load = 1'b1;
                timer_value = GREEN_MIN;
            end
            
            if (timer_expired) begin
                next_state = S_YELLOW;
                timer_load = 1'b1;
                timer_value = YELLOW_NORMAL;
            end
        end
    endcase
end

endmodule