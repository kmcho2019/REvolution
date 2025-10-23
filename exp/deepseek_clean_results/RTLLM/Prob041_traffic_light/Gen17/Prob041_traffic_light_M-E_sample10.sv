module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [7:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

// Timing parameters
parameter GREEN_TIME  = 60;
parameter YELLOW_TIME = 5;
parameter RED_TIME    = 10;
parameter MIN_GREEN   = 10;

// State encoding
typedef enum logic [1:0] {
    S_RED,
    S_YELLOW,
    S_GREEN
} state_t;

// Internal registers
state_t current_state, next_state;
reg [7:0] state_timer;
reg [7:0] total_timer;
reg pedestrian_active;

// Next state and timer calculation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= S_RED;
        state_timer <= RED_TIME;
        total_timer <= RED_TIME;
        pedestrian_active <= 0;
    end else begin
        // Update pedestrian active status
        pedestrian_active <= pass_request && (current_state == S_GREEN);
        
        // Handle state transitions
        if (state_timer == 0) begin
            case (current_state)
                S_RED: begin
                    next_state = S_GREEN;
                    state_timer <= GREEN_TIME;
                    total_timer <= GREEN_TIME;
                end
                S_YELLOW: begin
                    next_state = S_RED;
                    state_timer <= RED_TIME;
                    total_timer <= RED_TIME;
                end
                S_GREEN: begin
                    next_state = S_YELLOW;
                    state_timer <= YELLOW_TIME;
                    total_timer <= YELLOW_TIME;
                end
            endcase
            current_state <= next_state;
        end else begin
            // Handle pedestrian request with time compression
            if (pedestrian_active && (state_timer > MIN_GREEN)) begin
                state_timer <= MIN_GREEN;
                total_timer <= MIN_GREEN;
            end else begin
                state_timer <= state_timer - 1;
                total_timer <= total_timer - 1;
            end
        end
    end
end

// Output generation (registered)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        red <= 1;
        yellow <= 0;
        green <= 0;
    end else begin
        case (current_state)
            S_RED: begin
                red <= 1;
                yellow <= 0;
                green <= 0;
            end
            S_YELLOW: begin
                red <= 0;
                yellow <= 1;
                green <= 0;
            end
            S_GREEN: begin
                red <= 0;
                yellow <= 0;
                green <= 1;
            end
        endcase
    end
end

assign clock = total_timer;

endmodule