module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output reg [7:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

// Timing parameters (can be made inputs for dynamic adjustment)
parameter GREEN_TIME = 60;
parameter YELLOW_TIME = 5;
parameter RED_TIME = 10;
parameter MIN_GREEN = 10;
parameter WATCHDOG_LIMIT = 200;

// Gray-coded state definitions
typedef enum logic [1:0] {
    RED    = 2'b00,
    YELLOW = 2'b01,
    GREEN  = 2'b11
} state_t;

// Internal registers
state_t current_state, next_state;
reg [7:0] main_counter;
reg [7:0] watchdog_counter;
reg [7:0] next_counter;
reg preempt_active;

// Watchdog timer
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        watchdog_counter <= 0;
    end else begin
        if (watchdog_counter >= WATCHDOG_LIMIT) begin
            // Force reset if watchdog expires
            current_state <= RED;
            main_counter <= RED_TIME;
            watchdog_counter <= 0;
        end else begin
            watchdog_counter <= watchdog_counter + 1;
        end
    end
end

// State transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= RED;
        main_counter <= RED_TIME;
        preempt_active <= 0;
    end else begin
        current_state <= next_state;
        main_counter <= next_counter;
        
        // Reset preemption flag on state change
        if (current_state != next_state) begin
            preempt_active <= 0;
            watchdog_counter <= 0; // Reset watchdog on valid state change
        end
    end
end

// Next state and counter logic
always @(*) begin
    // Default values
    next_state = current_state;
    next_counter = main_counter;
    
    // Handle counter and state transitions
    if (main_counter == 0) begin
        case (current_state)
            RED: begin
                next_state = GREEN;
                next_counter = GREEN_TIME;
            end
            YELLOW: begin
                next_state = RED;
                next_counter = RED_TIME;
            end
            GREEN: begin
                next_state = YELLOW;
                next_counter = YELLOW_TIME;
            end
        endcase
    end else begin
        // Handle pedestrian preemption
        if (pass_request && current_state == GREEN && 
            !preempt_active && main_counter > MIN_GREEN) begin
            next_counter = MIN_GREEN;
            preempt_active <= 1;
        end else begin
            next_counter = main_counter - 1;
        end
    end
end

// Registered outputs
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        red <= 1'b0;
        yellow <= 1'b0;
        green <= 1'b0;
        clock <= 8'd0;
    end else begin
        case (current_state)
            RED: begin
                red <= 1'b1;
                yellow <= 1'b0;
                green <= 1'b0;
            end
            YELLOW: begin
                red <= 1'b0;
                yellow <= 1'b1;
                green <= 1'b0;
            end
            GREEN: begin
                red <= 1'b0;
                yellow <= 1'b0;
                green <= 1'b1;
            end
        endcase
        clock <= main_counter;
    end
end

endmodule