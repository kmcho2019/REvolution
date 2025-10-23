module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [7:0] clock,
    output red,
    output yellow,
    green
);

// Timing registers (configurable)
reg [7:0] green_time = 60;
reg [7:0] yellow_time = 5;
reg [7:0] red_time = 10;
reg [7:0] min_green = 10;

// State definitions
typedef enum logic [1:0] {
    S_RED,
    S_YELLOW,
    S_GREEN
} state_t;

state_t current_state, next_state;
reg [7:0] counter;
reg [7:0] next_counter;
reg pass_request_sync;
reg pass_request_edge;

// Output registers
reg r_red, r_yellow, r_green;

// Synchronizer for pedestrian button
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pass_request_sync <= 0;
        pass_request_edge <= 0;
    end else begin
        pass_request_sync <= pass_request;
        pass_request_edge <= pass_request && !pass_request_sync;
    end
end

// Main state machine
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= S_RED;
        counter <= red_time;
        r_red <= 1;
        r_yellow <= 0;
        r_green <= 0;
    end else begin
        current_state <= next_state;
        counter <= next_counter;
        
        // Update outputs
        r_red <= (next_state == S_RED);
        r_yellow <= (next_state == S_YELLOW);
        r_green <= (next_state == S_GREEN);
    end
end

// Next state and counter logic
always_comb begin
    // Default values
    next_state = current_state;
    next_counter = counter;
    
    // Watchdog timer
    if (counter == 0) begin
        case (current_state)
            S_RED: begin
                next_state = S_GREEN;
                next_counter = green_time;
            end
            S_YELLOW: begin
                next_state = S_RED;
                next_counter = red_time;
            end
            S_GREEN: begin
                next_state = S_YELLOW;
                next_counter = yellow_time;
            end
        endcase
    end else begin
        // Handle pedestrian preemption
        if (pass_request_edge && current_state == S_GREEN) begin
            if (counter > min_green) begin
                next_counter = min_green;
            end
        end
        
        // Normal countdown
        next_counter = counter - 1;
    end
end

// Output assignments
assign red = r_red;
assign yellow = r_yellow;
assign green = r_green;
assign clock = counter;

// Safety watchdog
always @(posedge clk) begin
    if (counter > 8'hFF) begin  // If counter overflows
        next_state <= S_RED;
        next_counter <= red_time;
    end
end

endmodule