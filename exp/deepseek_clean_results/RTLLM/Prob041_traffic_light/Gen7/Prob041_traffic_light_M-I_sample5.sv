module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [5:0] clock,  // Reduced from 8 to 6 bits
    output red,
    output yellow,
    output green
);

// Timing parameters
parameter GREEN_TIME = 60;
parameter YELLOW_TIME = 5;
parameter RED_TIME = 10;
parameter MIN_GREEN = 10;

// State encoding
typedef enum {IDLE, RED, YELLOW, GREEN} state_t;
state_t state, next_state;

// Registered signals
reg [5:0] cnt;  // 6-bit counter
reg pass_request_sync;

// Clock gating
wire counter_en = (state != IDLE) && !(cnt == 0 && (state == RED || state == YELLOW || state == GREEN));

// Synchronize pass_request
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pass_request_sync <= 1'b0;
    end else begin
        pass_request_sync <= pass_request;
    end
end

// State transition logic
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
        RED:    if (cnt == 0) next_state = GREEN;
        YELLOW: if (cnt == 0) next_state = RED;
        GREEN:  if (cnt == 0) next_state = YELLOW;
    endcase
end

// Counter management with clock gating
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= RED_TIME;
    end else if (counter_en) begin
        // Handle pedestrian request
        if (pass_request_sync && (state == GREEN) && (cnt > MIN_GREEN)) begin
            cnt <= MIN_GREEN;
        end
        // State transition counter updates
        else if (cnt == 0) begin
            case (state)
                RED:    cnt <= GREEN_TIME;
                YELLOW: cnt <= RED_TIME;
                GREEN:  cnt <= YELLOW_TIME;
                default: cnt <= RED_TIME;
            endcase
        end else begin
            cnt <= cnt - 1;
        end
    end
end

// Direct combinatorial outputs
assign clock = cnt;
assign red = (state == RED);
assign yellow = (state == YELLOW);
assign green = (state == GREEN);

endmodule