module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [5:0] clock,
    output reg [1:0] light // 00:red, 01:yellow, 10:green
);

// Timing parameters
parameter GREEN_TIME = 60;
parameter YELLOW_TIME = 5;
parameter RED_TIME = 10;
parameter MIN_GREEN = 10;

// Gray-coded state encoding
typedef enum logic [1:0] {
    IDLE  = 2'b00,
    RED   = 2'b01,
    GREEN = 2'b11,
    YELLOW = 2'b10
} state_t;
state_t state, next_state;

// Counter with clock gating
reg [5:0] cnt;
wire counter_enable = (cnt > 1) || (state == IDLE);

// State transition
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

// Next state and output logic
always @(*) begin
    // Default outputs
    light = 2'b00; // Red
    next_state = state;
    
    case (state)
        IDLE:   next_state = RED;
        
        RED: begin
            light = 2'b00; // Red
            if (cnt == 1) next_state = GREEN;
        end
        
        YELLOW: begin
            light = 2'b01; // Yellow
            if (cnt == 1) next_state = RED;
        end
        
        GREEN: begin
            light = 2'b10; // Green
            if (cnt == 1) next_state = YELLOW;
        end
    endcase
end

// Counter management with clock gating
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= RED_TIME;
    end else if (counter_enable) begin
        // Handle pedestrian request only when counter > MIN_GREEN
        if (pass_request && (state == GREEN) && (cnt > MIN_GREEN)) begin
            cnt <= MIN_GREEN;
        end
        // State transition counter updates
        else if (cnt == 1) begin
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

assign clock = cnt;

// Output decoding (if needed)
wire red = (light == 2'b00);
wire yellow = (light == 2'b01);
wire green = (light == 2'b10);

endmodule