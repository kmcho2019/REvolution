module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [5:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

// Timing parameters
parameter GREEN_TIME  = 60;
parameter YELLOW_TIME = 5;
parameter RED_TIME    = 10;
parameter MIN_GREEN   = 10;

// State encoding
typedef enum {RED, YELLOW, GREEN} state_t;
state_t state, next_state;

// Counter
reg [5:0] cnt;
reg [5:0] next_cnt;

// Next state logic (combinational)
always @(*) begin
    next_state = state;
    next_cnt = cnt;
    
    if (cnt == 0) begin
        case (state)
            RED:    begin next_state = GREEN;  next_cnt = GREEN_TIME;  end
            YELLOW: begin next_state = RED;    next_cnt = RED_TIME;    end
            GREEN: begin next_state = YELLOW; next_cnt = YELLOW_TIME; end
        endcase
    end else begin
        // Handle pedestrian request
        if (pass_request && (state == GREEN) && (cnt > MIN_GREEN))
            next_cnt = MIN_GREEN;
        else
            next_cnt = cnt - 1;
    end
end

// State and counter registers (sequential)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= RED;
        cnt <= RED_TIME;
    end else begin
        state <= next_state;
        cnt <= next_cnt;
    end
end

// Output generation (combinational)
always @(*) begin
    red    = (state == RED);
    yellow = (state == YELLOW);
    green  = (state == GREEN);
end

assign clock = cnt;

endmodule