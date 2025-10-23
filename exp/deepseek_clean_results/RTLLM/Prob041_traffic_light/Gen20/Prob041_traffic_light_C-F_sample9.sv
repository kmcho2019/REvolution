module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [5:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

// Timing parameters
parameter GREEN_TIME = 60;
parameter YELLOW_TIME = 5;
parameter RED_TIME = 10;
parameter MIN_GREEN = 10;

// State encoding
typedef enum {IDLE, RED, YELLOW, GREEN} state_t;
state_t state;
reg [5:0] cnt;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        red <= 1;
        yellow <= 0;
        green <= 0;
        cnt <= RED_TIME;
    end else begin
        // Default outputs
        red <= 0;
        yellow <= 0;
        green <= 0;
        
        // State machine with counter management
        case (state)
            IDLE: begin
                state <= RED;
                red <= 1;
                cnt <= RED_TIME;
            end
            
            RED: begin
                red <= 1;
                if (cnt == 1) begin
                    state <= GREEN;
                    cnt <= GREEN_TIME;
                end else begin
                    cnt <= cnt - 1;
                end
            end
            
            YELLOW: begin
                yellow <= 1;
                if (cnt == 1) begin
                    state <= RED;
                    cnt <= RED_TIME;
                end else begin
                    cnt <= cnt - 1;
                end
            end
            
            GREEN: begin
                green <= 1;
                // Handle pedestrian request
                if (pass_request && cnt > MIN_GREEN) begin
                    cnt <= MIN_GREEN;
                end
                
                if (cnt == 1) begin
                    state <= YELLOW;
                    cnt <= YELLOW_TIME;
                end else begin
                    cnt <= cnt - 1;
                end
            end
        endcase
    end
end

assign clock = cnt;

endmodule