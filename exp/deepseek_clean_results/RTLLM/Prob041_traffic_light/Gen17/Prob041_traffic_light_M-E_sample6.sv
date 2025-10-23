module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output reg [7:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

// Timing parameters
parameter GREEN_TIME = 60;
parameter YELLOW_TIME = 5;
parameter RED_TIME = 10;
parameter MIN_GREEN = 10;

// State definitions
typedef enum logic [1:0] {
    S_RED,
    S_YELLOW,
    S_GREEN
} state_t;

// Main state registers
state_t current_state, next_state;

// Timing control
reg [7:0] timer;
reg timer_expired;
wire load_timer;

// Shadow registers for outputs
reg red_shadow, yellow_shadow, green_shadow;

// Pedestrian request handling
reg pedestrian_pending;

// Timer controller
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        timer <= RED_TIME;
        timer_expired <= 0;
    end else begin
        if (load_timer) begin
            case (next_state)
                S_RED: timer <= RED_TIME;
                S_YELLOW: timer <= YELLOW_TIME;
                S_GREEN: timer <= GREEN_TIME;
            endcase
            timer_expired <= 0;
        end else if (timer > 0) begin
            timer <= timer - 1;
            timer_expired <= (timer == 1);
            
            // Handle pedestrian request
            if (current_state == S_GREEN && pass_request && timer > MIN_GREEN) begin
                timer <= MIN_GREEN;
                pedestrian_pending <= 1;
            end
        end else begin
            timer_expired <= 1;
        end
    end
end

// State transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= S_RED;
        next_state <= S_GREEN;
    end else begin
        if (timer_expired) begin
            current_state <= next_state;
            case (current_state)
                S_RED: next_state <= S_GREEN;
                S_YELLOW: next_state <= S_RED;
                S_GREEN: next_state <= S_YELLOW;
            endcase
        end
    end
end

// Output generation with shadow registers
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        red <= 1;
        yellow <= 0;
        green <= 0;
        red_shadow <= 1;
        yellow_shadow <= 0;
        green_shadow <= 0;
    end else begin
        // Update shadow registers
        case (current_state)
            S_RED: begin
                red_shadow <= 1;
                yellow_shadow <= 0;
                green_shadow <= 0;
            end
            S_YELLOW: begin
                red_shadow <= 0;
                yellow_shadow <= 1;
                green_shadow <= 0;
            end
            S_GREEN: begin
                red_shadow <= 0;
                yellow_shadow <= 0;
                green_shadow <= 1;
            end
        endcase
        
        // Update actual outputs
        red <= red_shadow;
        yellow <= yellow_shadow;
        green <= green_shadow;
    end
end

// Timer load control
assign load_timer = (current_state != next_state) || !rst_n;

// Clock output
always @(posedge clk) begin
    clock <= timer;
end

endmodule