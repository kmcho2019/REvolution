module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [5:0] clock,
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

// Counter and registered inputs
reg [5:0] cnt;
reg pass_request_reg;
wire counter_en;

// Clock gating for counter
assign counter_en = (state != next_state) || (cnt != 0) || pass_request;

// Input registration
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pass_request_reg <= 1'b0;
    end else begin
        pass_request_reg <= pass_request;
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
        cnt <= RED_TIME - 1;
    end else if (counter_en) begin
        // Handle pedestrian request
        if (pass_request_reg && (state == GREEN) && (cnt > MIN_GREEN - 1)) begin
            cnt <= MIN_GREEN - 1;
        end
        // State transition counter updates
        else if (cnt == 0) begin
            case (state)
                RED:    cnt <= GREEN_TIME - 1;
                YELLOW: cnt <= RED_TIME - 1;
                GREEN:  cnt <= YELLOW_TIME - 1;
                default: cnt <= RED_TIME - 1;
            endcase
        end else begin
            cnt <= cnt - 1;
        end
    end
end

// Output assignments (combinatorial from state)
assign clock = cnt;
assign red = (state == RED);
assign yellow = (state == YELLOW);
assign green = (state == GREEN);

endmodule