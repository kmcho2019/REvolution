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
parameter GREEN_DURATION  = 60;
parameter YELLOW_DURATION = 5;
parameter RED_DURATION    = 10;
parameter MIN_GREEN       = 10;

// State encoding
typedef enum logic [1:0] {
    S_RED,
    S_YELLOW,
    S_GREEN
} state_t;

state_t current_state, next_state;
reg [7:0] time_counter;
reg [7:0] next_counter;
reg early_transition;

// State transition and counter management
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= S_RED;
        time_counter <= RED_DURATION;
        early_transition <= 0;
    end else begin
        current_state <= next_state;
        time_counter <= next_counter;
        early_transition <= (pass_request && (current_state == S_GREEN) && 
                           (time_counter > MIN_GREEN));
    end
end

// Next state and counter logic
always @(*) begin
    // Default assignments
    next_state = current_state;
    next_counter = time_counter;
    
    case (current_state)
        S_RED: begin
            if (time_counter == 1) begin
                next_state = S_GREEN;
                next_counter = GREEN_DURATION;
            end else begin
                next_counter = time_counter - 1;
            end
        end
        
        S_YELLOW: begin
            if (time_counter == 1) begin
                next_state = S_RED;
                next_counter = RED_DURATION;
            end else begin
                next_counter = time_counter - 1;
            end
        end
        
        S_GREEN: begin
            if (early_transition || time_counter == 1) begin
                next_state = S_YELLOW;
                next_counter = YELLOW_DURATION;
            end else begin
                next_counter = time_counter - 1;
            end
        end
    endcase
end

// Output assignments (registered for better timing)
reg r_red, r_yellow, r_green;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        r_red <= 1'b1;
        r_yellow <= 1'b0;
        r_green <= 1'b0;
    end else begin
        r_red <= (next_state == S_RED);
        r_yellow <= (next_state == S_YELLOW);
        r_green <= (next_state == S_GREEN);
    end
end

assign red = r_red;
assign yellow = r_yellow;
assign green = r_green;
assign clock = time_counter;

endmodule