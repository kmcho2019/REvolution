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
typedef enum {RED, YELLOW, GREEN} state_t;
state_t state, next_state;

// Counter
reg [5:0] cnt;

// State transition
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= RED;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always @(*) begin
    next_state = state;
    case (state)
        RED:    if (cnt == 1) next_state = GREEN;
        YELLOW: if (cnt == 1) next_state = RED;
        GREEN:  if (cnt == 1) next_state = YELLOW;
    endcase
end

// Output logic
always @(*) begin
    red = (state == RED);
    yellow = (state == YELLOW);
    green = (state == GREEN);
end

// Counter management
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= RED_TIME;
    end else begin
        // Handle pedestrian request
        if (pass_request && (state == GREEN) && (cnt > MIN_GREEN)) begin
            cnt <= MIN_GREEN;
        end
        // State transition counter updates
        else if (cnt == 1) begin
            case (state)
                RED:    cnt <= GREEN_TIME;
                YELLOW: cnt <= RED_TIME;
                GREEN:  cnt <= YELLOW_TIME;
            endcase
        end else begin
            cnt <= cnt - 1;
        end
    end
end

assign clock = cnt;

endmodule