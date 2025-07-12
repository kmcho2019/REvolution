module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [5:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

// State encoding using enum
typedef enum {RED, YELLOW, GREEN} state_t;
state_t state, next_state;

// Timing parameters
localparam [5:0] RED_TIME    = 6'd10;
localparam [5:0] YELLOW_TIME = 6'd5;
localparam [5:0] GREEN_TIME  = 6'd60;
localparam [5:0] MIN_GREEN   = 6'd10;

// Counter
reg [5:0] cnt;

// State transition
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= RED;
        cnt <= RED_TIME;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always @(*) begin
    next_state = state;
    
    case (state)
        RED: begin
            if (cnt == 1) next_state = GREEN;
        end
        
        YELLOW: begin
            if (cnt == 1) next_state = RED;
        end
        
        GREEN: begin
            if (cnt == 1) next_state = YELLOW;
        end
    endcase
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

// Output logic
always @(*) begin
    red = (state == RED);
    yellow = (state == YELLOW);
    green = (state == GREEN);
end

assign clock = cnt;

endmodule