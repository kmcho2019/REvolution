module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output reg [7:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

// State definitions
typedef enum logic [1:0] {
    S_RED,
    S_YELLOW,
    S_GREEN,
    S_IDLE
} state_t;

// Default durations
parameter RED_DEFAULT = 10;
parameter YELLOW_DEFAULT = 5;
parameter GREEN_DEFAULT = 60;
parameter GREEN_MIN = 10;

// Internal registers
state_t current_state, next_state;
reg [7:0] red_duration = RED_DEFAULT;
reg [7:0] yellow_duration = YELLOW_DEFAULT;
reg [7:0] green_duration = GREEN_DEFAULT;
reg [7:0] time_slice;
reg pass_request_sync, pass_request_edge;

// Synchronize and detect edge of pedestrian request
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pass_request_sync <= 0;
        pass_request_edge <= 0;
    end else begin
        pass_request_sync <= pass_request;
        pass_request_edge <= pass_request && !pass_request_sync;
    end
end

// State transition and duration control
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= S_IDLE;
        next_state <= S_RED;
        time_slice <= RED_DEFAULT;
        red_duration <= RED_DEFAULT;
        yellow_duration <= YELLOW_DEFAULT;
        green_duration <= GREEN_DEFAULT;
    end else begin
        // Handle state transitions
        current_state <= next_state;
        
        // Update time slice and determine next state
        if (time_slice == 0) begin
            case (current_state)
                S_RED: begin
                    next_state <= S_GREEN;
                    time_slice <= green_duration;
                end
                S_YELLOW: begin
                    next_state <= S_RED;
                    time_slice <= red_duration;
                end
                S_GREEN: begin
                    next_state <= S_YELLOW;
                    time_slice <= yellow_duration;
                end
                S_IDLE: begin
                    next_state <= S_RED;
                    time_slice <= red_duration;
                end
            endcase
        end else begin
            time_slice <= time_slice - 1;
        end
        
        // Handle pedestrian request during green
        if (current_state == S_GREEN && pass_request_edge) begin
            if (time_slice > GREEN_MIN) begin
                time_slice <= GREEN_MIN;
            end
        end
        
        // Reset durations when leaving states
        if (next_state == S_GREEN) green_duration <= GREEN_DEFAULT;
        if (next_state == S_YELLOW) yellow_duration <= YELLOW_DEFAULT;
        if (next_state == S_RED) red_duration <= RED_DEFAULT;
    end
end

// Output generation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        {red, yellow, green} <= 3'b000;
        clock <= 0;
    end else begin
        clock <= time_slice;
        case (next_state)
            S_RED: {red, yellow, green} <= 3'b100;
            S_YELLOW: {red, yellow, green} <= 3'b010;
            S_GREEN: {red, yellow, green} <= 3'b001;
            default: {red, yellow, green} <= 3'b000;
        endcase
    end
end

endmodule