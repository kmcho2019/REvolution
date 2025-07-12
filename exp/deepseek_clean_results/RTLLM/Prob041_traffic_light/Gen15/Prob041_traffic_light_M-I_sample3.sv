module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [5:0] clock,
    output reg [1:0] light // 00: off, 01: red, 10: yellow, 11: green
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
    YELLOW= 2'b10
} state_t;
state_t state, next_state;

// Counter with clock gating
reg [5:0] cnt;
wire cnt_en = (cnt != 1) || (state != next_state); // Enable only when counting or about to load

// Debounced pedestrian request
reg pass_request_sync;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) pass_request_sync <= 1'b0;
    else pass_request_sync <= pass_request;
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
    light = 2'b00;
    next_state = state;
    
    case (state)
        IDLE:   next_state = RED;
        
        RED: begin
            light = 2'b01; // red
            if (cnt == 1) next_state = GREEN;
        end
        
        YELLOW: begin
            light = 2'b10; // yellow
            if (cnt == 1) next_state = RED;
        end
        
        GREEN: begin
            light = 2'b11; // green
            if (cnt == 1) next_state = YELLOW;
        end
    endcase
end

// Counter management with synchronous load
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= RED_TIME;
    end else if (cnt_en) begin
        // Handle pedestrian request
        if (pass_request_sync && (state == GREEN) && (cnt > MIN_GREEN)) begin
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

endmodule