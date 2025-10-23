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
parameter GREEN_TIME = 60;
parameter YELLOW_TIME = 5;
parameter RED_TIME = 10;
parameter MIN_GREEN = 10;

// State encoding
typedef enum logic [1:0] {
    S_RED,
    S_YELLOW,
    S_GREEN
} state_t;

state_t state, next_state;
reg [7:0] phase_counter;  // Counts duration of current phase
reg [7:0] time_remaining; // Counts down remaining time
reg request_latch;        // Latches pedestrian requests

// One-hot light outputs
assign {red, yellow, green} = (state == S_RED) ? 3'b100 :
                             (state == S_YELLOW) ? 3'b010 :
                             3'b001;

assign clock = time_remaining;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= S_RED;
        next_state <= S_GREEN;
        phase_counter <= RED_TIME;
        time_remaining <= RED_TIME;
        request_latch <= 0;
    end else begin
        // Update request latch
        if (state == S_GREEN && pass_request)
            request_latch <= 1;
        else if (state != S_GREEN)
            request_latch <= 0;

        // Handle time counting
        if (time_remaining > 0) begin
            time_remaining <= time_remaining - 1;
            
            // Handle pedestrian request
            if (state == S_GREEN && request_latch && 
                time_remaining > MIN_GREEN && phase_counter > MIN_GREEN)
                time_remaining <= MIN_GREEN;
        end else begin
            // Time expired, transition to next state
            state <= next_state;
            
            case (next_state)
                S_RED: begin
                    next_state <= S_GREEN;
                    phase_counter <= GREEN_TIME;
                    time_remaining <= GREEN_TIME;
                end
                S_YELLOW: begin
                    next_state <= S_RED;
                    phase_counter <= RED_TIME;
                    time_remaining <= RED_TIME;
                end
                S_GREEN: begin
                    next_state <= S_YELLOW;
                    phase_counter <= YELLOW_TIME;
                    time_remaining <= YELLOW_TIME;
                end
            endcase
        end

        // Update phase counter (for pedestrian logic)
        if (state != next_state)
            phase_counter <= (next_state == S_RED) ? RED_TIME :
                           (next_state == S_YELLOW) ? YELLOW_TIME :
                           GREEN_TIME;
        else if (phase_counter > 0)
            phase_counter <= phase_counter - 1;
    end
end

endmodule