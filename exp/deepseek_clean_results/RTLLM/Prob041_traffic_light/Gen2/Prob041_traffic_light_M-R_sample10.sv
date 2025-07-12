module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [7:0] clock,
    output red,
    output yellow,
    output green
);

// Parameters for timing
parameter RED_TIME    = 8'd10;
parameter YELLOW_TIME = 8'd5;
parameter GREEN_TIME  = 8'd60;
parameter MIN_GREEN   = 8'd10;

// State encoding
typedef enum logic [1:0] {
    IDLE,
    RED,
    YELLOW,
    GREEN
} state_t;

state_t state, next_state;
reg [7:0] cnt;

// Continuous output assignments
assign red    = (state == RED);
assign yellow = (state == YELLOW);
assign green  = (state == GREEN);
assign clock  = cnt;

// State transition logic
always_comb begin
    next_state = state;
    case (state)
        IDLE:   next_state = RED;
        RED:    if (cnt == 1) next_state = GREEN;
        YELLOW: if (cnt == 1) next_state = RED;
        GREEN:  if (cnt == 1) next_state = YELLOW;
    endcase
end

// Counter and state update logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= RED;
        cnt <= RED_TIME;
    end else begin
        state <= next_state;
        
        // Handle counter updates
        if (state != next_state) begin
            // State transition - load new counter value
            case (next_state)
                RED:    cnt <= RED_TIME;
                YELLOW: cnt <= YELLOW_TIME;
                GREEN:  cnt <= GREEN_TIME;
                default: cnt <= RED_TIME;
            endcase
        end else if (state == GREEN && pass_request && cnt > MIN_GREEN) begin
            // Pedestrian request during green phase
            cnt <= MIN_GREEN;
        end else if (cnt > 0) begin
            // Normal countdown
            cnt <= cnt - 1;
        end
    end
end

endmodule