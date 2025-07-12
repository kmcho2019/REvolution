module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [7:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

// Parameters
parameter BASE_GREEN = 60;
parameter BASE_YELLOW = 5;
parameter BASE_RED = 10;
parameter MIN_GREEN = 10;
parameter TIME_BANK_MAX = 20;

// State encoding
typedef enum {IDLE, RED, YELLOW, GREEN} state_t;
reg [1:0] state, next_state;

// Timing control
reg [7:0] time_remaining;
reg [7:0] time_bank;
reg [7:0] next_duration;
wire time_expired = (time_remaining == 0);

// Priority encoder outputs
wire pedestrian_priority;
wire normal_operation;

// Priority encoder
assign pedestrian_priority = pass_request && (state == GREEN) && 
                           (time_remaining > MIN_GREEN);
assign normal_operation = !pedestrian_priority;

// Time banking logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        time_bank <= 0;
    end else begin
        if (state == GREEN && time_expired && time_remaining > 0) begin
            // Bank unused time (up to maximum)
            if (time_bank + (time_remaining) <= TIME_BANK_MAX)
                time_bank <= time_bank + time_remaining;
            else
                time_bank <= TIME_BANK_MAX;
        end
        else if (state == GREEN && pedestrian_priority) begin
            // Use banked time to compensate for early transition
            if (time_bank >= (time_remaining - MIN_GREEN))
                time_bank <= time_bank - (time_remaining - MIN_GREEN);
            else
                time_bank <= 0;
        end
    end
end

// Duration calculator
always @(*) begin
    case (state)
        RED:    next_duration = BASE_RED;
        YELLOW: next_duration = BASE_YELLOW;
        GREEN:  next_duration = BASE_GREEN + time_bank;
        default: next_duration = BASE_RED;
    endcase
    
    // Override for pedestrian request
    if (pedestrian_priority)
        next_duration = MIN_GREEN;
end

// Time remaining counter
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        time_remaining <= BASE_RED;
    end else begin
        if (time_expired || (pedestrian_priority && state == GREEN)) begin
            time_remaining <= next_duration;
        end else begin
            time_remaining <= time_remaining - 1;
        end
    end
end

// State machine
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always @(*) begin
    next_state = state;
    
    case (state)
        IDLE:   next_state = RED;
        RED:    if (time_expired) next_state = GREEN;
        YELLOW: if (time_expired) next_state = RED;
        GREEN:  if (time_expired || pedestrian_priority) next_state = YELLOW;
    endcase
end

// Output logic
always @(*) begin
    red = 1'b0;
    yellow = 1'b0;
    green = 1'b0;
    
    case (state)
        RED:    red = 1'b1;
        YELLOW: yellow = 1'b1;
        GREEN:  green = 1'b1;
    endcase
end

assign clock = time_remaining;

endmodule