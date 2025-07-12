module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output reg [7:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

// Main states
typedef enum logic [1:0] {
    ST_IDLE,
    ST_RED,
    ST_YELLOW,
    ST_GREEN
} state_t;

// Timing control states
typedef enum logic {
    TM_COUNTING,
    TM_EXPIRED
} timing_state_t;

// Parameters
parameter RED_TIME    = 8'd10;
parameter YELLOW_TIME = 8'd5;
parameter GREEN_TIME  = 8'd60;
parameter REQ_TIME    = 8'd10;

// Main state registers
state_t current_state, next_state;

// Timing control registers
timing_state_t tm_state;
reg [7:0] time_left;
reg load_timer;
reg [7:0] timer_value;

// Output registers
reg next_red, next_yellow, next_green;

// Main state machine
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= ST_IDLE;
    end else begin
        current_state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (current_state)
        ST_IDLE: begin
            next_state = ST_RED;
        end
        ST_RED: begin
            next_state = (tm_state == TM_EXPIRED) ? ST_GREEN : ST_RED;
        end
        ST_YELLOW: begin
            next_state = (tm_state == TM_EXPIRED) ? ST_RED : ST_YELLOW;
        end
        ST_GREEN: begin
            next_state = (tm_state == TM_EXPIRED) ? ST_YELLOW : ST_GREEN;
        end
        default: next_state = ST_IDLE;
    endcase
end

// Timing control state machine
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        tm_state <= TM_COUNTING;
        time_left <= RED_TIME;
        timer_value <= RED_TIME;
    end else begin
        if (load_timer) begin
            time_left <= timer_value;
            tm_state <= TM_COUNTING;
        end else if (time_left == 0) begin
            tm_state <= TM_EXPIRED;
        end else begin
            time_left <= time_left - 1;
            tm_state <= TM_COUNTING;
        end
    end
end

// Timer control logic
always @(*) begin
    load_timer = 1'b0;
    timer_value = time_left;
    
    case (current_state)
        ST_IDLE: begin
            load_timer = 1'b1;
            timer_value = RED_TIME;
        end
        ST_RED: begin
            if (next_state == ST_GREEN) begin
                load_timer = 1'b1;
                timer_value = GREEN_TIME;
            end
        end
        ST_YELLOW: begin
            if (next_state == ST_RED) begin
                load_timer = 1'b1;
                timer_value = RED_TIME;
            end
        end
        ST_GREEN: begin
            if (pass_request && (time_left > REQ_TIME)) begin
                load_timer = 1'b1;
                timer_value = REQ_TIME;
            end else if (next_state == ST_YELLOW) begin
                load_timer = 1'b1;
                timer_value = YELLOW_TIME;
            end
        end
    endcase
end

// Output logic
always @(*) begin
    case (current_state)
        ST_IDLE: begin
            next_red = 1'b0;
            next_yellow = 1'b0;
            next_green = 1'b0;
        end
        ST_RED: begin
            next_red = 1'b1;
            next_yellow = 1'b0;
            next_green = 1'b0;
        end
        ST_YELLOW: begin
            next_red = 1'b0;
            next_yellow = 1'b1;
            next_green = 1'b0;
        end
        ST_GREEN: begin
            next_red = 1'b0;
            next_yellow = 1'b0;
            next_green = 1'b1;
        end
    endcase
end

// Output registers
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        red <= 1'b0;
        yellow <= 1'b0;
        green <= 1'b0;
        clock <= 8'b0;
    end else begin
        red <= next_red;
        yellow <= next_yellow;
        green <= next_green;
        clock <= time_left;
    end
end

endmodule