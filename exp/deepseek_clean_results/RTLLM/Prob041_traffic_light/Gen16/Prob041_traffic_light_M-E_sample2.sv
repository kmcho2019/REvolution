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

state_t current_state, next_state;
reg [7:0] main_counter;
reg [7:0] shadow_counter;
reg pedestrian_pending;
reg time_bank; // Carry-over time indicator

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= S_RED;
        main_counter <= RED_TIME;
        shadow_counter <= RED_TIME;
        pedestrian_pending <= 0;
        time_bank <= 0;
        {red, yellow, green} <= 3'b100;
    end else begin
        // Handle pedestrian requests
        if (pass_request && current_state == S_GREEN) begin
            if (main_counter > MIN_GREEN) begin
                shadow_counter <= main_counter;
                main_counter <= MIN_GREEN;
                pedestrian_pending <= 1;
            end
        end

        // Main counter logic
        if (main_counter > 0) begin
            main_counter <= main_counter - 1;
        end else begin
            // State transition
            current_state <= next_state;
            
            // Time banking logic
            if (pedestrian_pending && current_state == S_GREEN) begin
                main_counter <= shadow_counter - MIN_GREEN;
                time_bank <= 1;
                pedestrian_pending <= 0;
            end else begin
                case (next_state)
                    S_RED:    main_counter <= RED_TIME;
                    S_YELLOW: main_counter <= YELLOW_TIME;
                    S_GREEN:  main_counter <= time_bank ? GREEN_TIME + (shadow_counter - MIN_GREEN) : GREEN_TIME;
                endcase
                time_bank <= 0;
            end
        end

        // Next state prediction
        case (current_state)
            S_RED:    next_state <= S_GREEN;
            S_YELLOW: next_state <= S_RED;
            S_GREEN:  next_state <= S_YELLOW;
        endcase

        // Output generation
        case (current_state)
            S_RED:    {red, yellow, green} <= 3'b100;
            S_YELLOW: {red, yellow, green} <= 3'b010;
            S_GREEN:  {red, yellow, green} <= 3'b001;
        endcase
    end
end

assign clock = main_counter;

endmodule