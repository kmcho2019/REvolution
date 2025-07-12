module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [7:0] clock,
    output red,
    output yellow,
    output green
);

// State definitions
typedef enum logic [1:0] {
    IDLE,
    RED,
    YELLOW,
    GREEN
} state_t;

// Timing parameters
parameter RED_DURATION   = 10;
parameter YELLOW_DURATION = 5;
parameter GREEN_DURATION  = 60;
parameter MIN_GREEN       = 10;

// Internal signals
state_t current_state, next_state;
reg [7:0] counter;
reg pass_request_sync, pass_request_edge;

// Synchronize and detect rising edge of pedestrian request
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pass_request_sync <= 0;
        pass_request_edge <= 0;
    end else begin
        pass_request_sync <= pass_request;
        pass_request_edge <= pass_request && !pass_request_sync;
    end
end

// State transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= IDLE;
        counter <= RED_DURATION;
    end else begin
        current_state <= next_state;
        
        // Counter management
        if (current_state != next_state) begin
            case (next_state)
                RED:    counter <= RED_DURATION;
                YELLOW: counter <= YELLOW_DURATION;
                GREEN:  counter <= GREEN_DURATION;
                default: counter <= RED_DURATION;
            endcase
        end else if (pass_request_edge && current_state == GREEN && counter > MIN_GREEN) begin
            counter <= MIN_GREEN;
        end else if (counter > 0) begin
            counter <= counter - 1;
        end
    end
end

// Next state logic
always @(*) begin
    case (current_state)
        IDLE:   next_state = RED;
        RED:    next_state = (counter == 0) ? GREEN : RED;
        YELLOW: next_state = (counter == 0) ? RED : YELLOW;
        GREEN:  next_state = (counter == 0) ? YELLOW : GREEN;
        default: next_state = RED;
    endcase
end

// Output logic
assign red    = (current_state == RED);
assign yellow = (current_state == YELLOW);
assign green  = (current_state == GREEN);
assign clock  = counter;

endmodule