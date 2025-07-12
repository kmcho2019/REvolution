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
    YELLOW = 2'b11,
    GREEN = 2'b10
} state_t;

state_t state, next_state;

// Counter with clock gating
reg [5:0] cnt;
wire cnt_enable;
reg pass_request_sync;
reg pass_request_edge;

// Synchronize and edge detect pass_request
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pass_request_sync <= 1'b0;
        pass_request_edge <= 1'b0;
    end else begin
        pass_request_sync <= pass_request;
        pass_request_edge <= pass_request & ~pass_request_sync;
    end
end

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
    light = 2'b00; // red
    next_state = state;
    
    case (state)
        IDLE:   next_state = RED;
        
        RED: begin
            light = 2'b00; // red
            if (cnt == 1) next_state = GREEN;
        end
        
        YELLOW: begin
            light = 2'b01; // yellow
            if (cnt == 1) next_state = RED;
        end
        
        GREEN: begin
            light = 2'b10; // green
            if (cnt == 1) next_state = YELLOW;
        end
    endcase
end

// Counter enable logic
assign cnt_enable = (state != IDLE) && 
                   !((state == RED && cnt == 1) ||
                    (state == YELLOW && cnt == 1) ||
                    (state == GREEN && cnt == 1));

// Counter management with synchronous load
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= RED_TIME;
    end else begin
        // Handle pedestrian request
        if (pass_request_edge && (state == GREEN) && (cnt > MIN_GREEN)) begin
            cnt <= MIN_GREEN;
        end
        // State transition counter updates
        else if (!cnt_enable) begin
            case (next_state)
                RED:    cnt <= RED_TIME;
                YELLOW: cnt <= YELLOW_TIME;
                GREEN:  cnt <= GREEN_TIME;
                default: cnt <= RED_TIME;
            endcase
        end else if (cnt_enable) begin
            cnt <= cnt - 1;
        end
    end
end

assign clock = cnt;

endmodule