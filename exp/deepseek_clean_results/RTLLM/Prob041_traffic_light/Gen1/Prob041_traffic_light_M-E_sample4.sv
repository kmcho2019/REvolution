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
    IDLE,
    RED,
    YELLOW,
    GREEN
} state_t;

// Duration parameters
parameter RED_DURATION = 10;
parameter YELLOW_DURATION = 5;
parameter GREEN_DURATION = 60;
parameter MIN_GREEN = 10;

// Internal signals
state_t current_state, next_state;
reg [7:0] counter;
reg [7:0] target_duration;
reg force_short_green;

// State transition and counter control
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= IDLE;
        counter <= RED_DURATION;
        target_duration <= RED_DURATION;
        force_short_green <= 0;
    end
    else begin
        // Handle pedestrian request asynchronously
        if (pass_request && current_state == GREEN && counter > MIN_GREEN) begin
            force_short_green <= 1;
        end

        // State transition logic
        case (current_state)
            IDLE: begin
                current_state <= RED;
                counter <= RED_DURATION;
                target_duration <= RED_DURATION;
            end
            
            RED: begin
                if (counter == 0) begin
                    current_state <= GREEN;
                    counter <= GREEN_DURATION;
                    target_duration <= GREEN_DURATION;
                    force_short_green <= 0;
                end
                else begin
                    counter <= counter - 1;
                end
            end
            
            YELLOW: begin
                if (counter == 0) begin
                    current_state <= RED;
                    counter <= RED_DURATION;
                    target_duration <= RED_DURATION;
                end
                else begin
                    counter <= counter - 1;
                end
            end
            
            GREEN: begin
                if (force_short_green && counter > MIN_GREEN) begin
                    counter <= MIN_GREEN;
                    force_short_green <= 0;
                end
                else if (counter == 0) begin
                    current_state <= YELLOW;
                    counter <= YELLOW_DURATION;
                    target_duration <= YELLOW_DURATION;
                end
                else begin
                    counter <= counter - 1;
                end
            end
        endcase
    end
end

// Output generation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        red <= 0;
        yellow <= 0;
        green <= 0;
        clock <= 0;
    end
    else begin
        case (current_state)
            RED: begin
                red <= 1;
                yellow <= 0;
                green <= 0;
            end
            YELLOW: begin
                red <= 0;
                yellow <= 1;
                green <= 0;
            end
            GREEN: begin
                red <= 0;
                yellow <= 0;
                green <= 1;
            end
            default: begin
                red <= 0;
                yellow <= 0;
                green <= 0;
            end
        endcase
        clock <= counter;
    end
end

endmodule