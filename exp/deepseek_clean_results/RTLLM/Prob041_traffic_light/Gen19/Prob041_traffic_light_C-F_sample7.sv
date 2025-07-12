module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output reg [5:0] clock,
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
reg [1:0] state;

// Counter
reg [5:0] cnt;

// State transition and output logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        red <= 1'b0;
        yellow <= 1'b0;
        green <= 1'b0;
        cnt <= RED_TIME;
    end else begin
        // Default outputs
        red <= 1'b0;
        yellow <= 1'b0;
        green <= 1'b0;
        
        // Handle pedestrian request
        if (state == GREEN && pass_request && cnt > MIN_GREEN)
            cnt <= MIN_GREEN;
        else if (cnt == 1) begin
            // State transition
            case (state)
                IDLE: begin
                    state <= RED;
                    cnt <= RED_TIME;
                end
                RED: begin
                    state <= GREEN;
                    cnt <= GREEN_TIME;
                end
                YELLOW: begin
                    state <= RED;
                    cnt <= RED_TIME;
                end
                GREEN: begin
                    state <= YELLOW;
                    cnt <= YELLOW_TIME;
                end
            endcase
        end else begin
            cnt <= cnt - 1;
        end
        
        // Set outputs based on state
        case (state)
            RED:    red <= 1'b1;
            YELLOW: yellow <= 1'b1;
            GREEN:  green <= 1'b1;
            default: ; // IDLE state
        endcase
    end
end

assign clock = cnt;

endmodule