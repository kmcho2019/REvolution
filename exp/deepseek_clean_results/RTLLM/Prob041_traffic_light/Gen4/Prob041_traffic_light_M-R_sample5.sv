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
state_t current_state, next_state;

// Counter logic - combinational
assign clock = cnt;
assign cnt = (!rst_n) ? RED_TIME : 
             (current_state == GREEN && pass_request && cnt > MIN_GREEN) ? MIN_GREEN :
             cnt - 1'b1;

// State transition logic - combinational
always @(*) begin
    case (current_state)
        IDLE: next_state = RED;
        RED: next_state = (cnt == 1) ? GREEN : RED;
        YELLOW: next_state = (cnt == 1) ? RED : YELLOW;
        GREEN: next_state = (cnt == 1) ? YELLOW : GREEN;
        default: next_state = IDLE;
    endcase
end

// State register - sequential
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

// Output generation - combinational
assign red = (current_state == RED);
assign yellow = (current_state == YELLOW);
assign green = (current_state == GREEN);

endmodule