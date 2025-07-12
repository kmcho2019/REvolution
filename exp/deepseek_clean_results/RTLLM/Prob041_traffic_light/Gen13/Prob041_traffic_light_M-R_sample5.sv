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
parameter RED_TIME = 10;
parameter YELLOW_TIME = 5;
parameter GREEN_TIME = 60;
parameter MIN_GREEN = 10;

// State encoding
typedef enum {RED, YELLOW, GREEN} state_t;
state_t state, next_state;

// Counter and control signals
reg [7:0] cnt;
wire counter_expired = (cnt == 0);
wire pedestrian_override = (pass_request && (state == GREEN) && (cnt > MIN_GREEN));

// State transition logic
always @(*) begin
    next_state = state; // Default: stay in current state
    
    if (counter_expired) begin
        case (state)
            RED:    next_state = GREEN;
            YELLOW: next_state = RED;
            GREEN:  next_state = YELLOW;
            default: next_state = RED;
        endcase
    end
end

// Counter and state update logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= RED;
        cnt <= RED_TIME;
    end else begin
        state <= next_state;
        
        // Update counter based on state transitions
        if (counter_expired) begin
            case (next_state)
                RED:    cnt <= RED_TIME;
                YELLOW: cnt <= YELLOW_TIME;
                GREEN:  cnt <= GREEN_TIME;
                default: cnt <= RED_TIME;
            endcase
        end else if (pedestrian_override) begin
            cnt <= MIN_GREEN;
        end else begin
            cnt <= cnt - 1;
        end
    end
end

// Output logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        red <= 1'b1;
        yellow <= 1'b0;
        green <= 1'b0;
        clock <= RED_TIME;
    end else begin
        red <= (state == RED);
        yellow <= (state == YELLOW);
        green <= (state == GREEN);
        clock <= cnt;
    end
end

endmodule