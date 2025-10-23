module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [7:0] clock,
    output red,
    output yellow,
    output green
);

// Timing parameters
parameter RED_TIME   = 8'd10;
parameter YELLOW_TIME = 8'd5;
parameter GREEN_TIME = 8'd60;
parameter MIN_GREEN  = 8'd10;

// State definitions
typedef enum logic [1:0] {
    IDLE,
    RED,
    YELLOW,
    GREEN
} state_t;

// Internal signals
reg [7:0] cnt;
reg [7:0] next_cnt;
state_t state;
state_t next_state;
wire cnt_decrement = (cnt != 0);

// State transition logic (combinational)
always @(*) begin
    next_state = state;
    next_cnt = cnt;
    
    case (state)
        IDLE: begin
            next_state = RED;
            next_cnt = RED_TIME;
        end
        
        RED: begin
            if (cnt == 1) begin
                next_state = GREEN;
                next_cnt = GREEN_TIME;
            end else begin
                next_cnt = cnt - cnt_decrement;
            end
        end
        
        YELLOW: begin
            if (cnt == 1) begin
                next_state = RED;
                next_cnt = RED_TIME;
            end else begin
                next_cnt = cnt - cnt_decrement;
            end
        end
        
        GREEN: begin
            // Handle pedestrian request (combinational)
            if (pass_request && (cnt > MIN_GREEN)) begin
                next_cnt = MIN_GREEN;
            end
            
            // State transition
            if (cnt == 1) begin
                next_state = YELLOW;
                next_cnt = YELLOW_TIME;
            end else begin
                next_cnt = cnt - cnt_decrement;
            end
        end
        
        default: begin
            next_state = IDLE;
            next_cnt = RED_TIME;
        end
    endcase
end

// Sequential logic (state and counter update)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        cnt <= RED_TIME;
    end else begin
        state <= next_state;
        cnt <= next_cnt;
    end
end

// Output assignments (combinational)
assign red = (state == RED);
assign yellow = (state == YELLOW);
assign green = (state == GREEN);
assign clock = cnt;

endmodule