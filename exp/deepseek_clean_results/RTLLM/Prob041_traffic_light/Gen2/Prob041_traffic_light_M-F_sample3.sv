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

// State transition and counter control
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= IDLE;
        counter <= RED_DURATION;
    end
    else begin
        case (current_state)
            IDLE: begin
                current_state <= RED;
                counter <= RED_DURATION;
            end
            
            RED: begin
                if (counter == 0) begin
                    current_state <= GREEN;
                    counter <= GREEN_DURATION;
                end
                else begin
                    counter <= counter - 1;
                end
            end
            
            YELLOW: begin
                if (counter == 0) begin
                    current_state <= RED;
                    counter <= RED_DURATION;
                end
                else begin
                    counter <= counter - 1;
                end
            end
            
            GREEN: begin
                // Handle pedestrian request
                if (pass_request && counter > MIN_GREEN) begin
                    counter <= MIN_GREEN;
                end
                else if (counter == 0) begin
                    current_state <= YELLOW;
                    counter <= YELLOW_DURATION;
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
        clock <= counter;
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
    end
end

endmodule