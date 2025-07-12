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

// Registered inputs
reg pass_request_reg;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) pass_request_reg <= 1'b0;
    else pass_request_reg <= pass_request;
end

// Counter
reg [5:0] cnt;
reg cnt_en;  // Clock gating signal

// State transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

// Next state and counter control logic
always @(*) begin
    next_state = state;
    cnt_en = 1'b1;  // Default enable counter
    
    case (state)
        IDLE:   next_state = RED;
        RED:    if (cnt == 0) next_state = GREEN;
        YELLOW: if (cnt == 0) next_state = RED;
        GREEN: begin
            if (cnt == 0) next_state = YELLOW;
            // Disable counter when not near transition and no request
            else if (cnt > MIN_GREEN && !pass_request_reg) cnt_en = 1'b0;
        end
        default: next_state = IDLE;
    endcase
end

// Counter management
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= RED_TIME;
    end else if (cnt_en) begin
        // Handle pedestrian request
        if (pass_request_reg && (state == GREEN) && (cnt > MIN_GREEN)) begin
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

// Combinatorial outputs from state
assign clock = cnt;
assign red = (state == RED);
assign yellow = (state == YELLOW);
assign green = (state == GREEN);

endmodule