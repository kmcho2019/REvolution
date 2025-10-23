module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [5:0] clock,
    output red,
    output yellow,
    output green
);

// State encoding
parameter IDLE = 2'b00;
parameter RED = 2'b01;
parameter YELLOW = 2'b10;
parameter GREEN = 2'b11;

// Timing parameters
parameter RED_TIME = 10;
parameter YELLOW_TIME = 5;
parameter GREEN_TIME = 60;
parameter MIN_GREEN = 10;

reg [1:0] state, next_state;
reg [5:0] cnt, next_cnt;

// State transition and counter logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= RED;
        cnt <= RED_TIME;
    end else begin
        state <= next_state;
        cnt <= next_cnt;
    end
end

// Next state and counter logic
always @(*) begin
    next_state = state;
    next_cnt = cnt;
    
    if (cnt == 0) begin
        case (state)
            RED: begin
                next_state = GREEN;
                next_cnt = GREEN_TIME;
            end
            YELLOW: begin
                next_state = RED;
                next_cnt = RED_TIME;
            end
            GREEN: begin
                next_state = YELLOW;
                next_cnt = YELLOW_TIME;
            end
            default: begin
                next_state = RED;
                next_cnt = RED_TIME;
            end
        endcase
    end else begin
        // Handle pedestrian request during green
        if (state == GREEN && pass_request && cnt > MIN_GREEN) begin
            next_cnt = MIN_GREEN;
        end else begin
            next_cnt = cnt - 1;
        end
    end
end

// Output generation
assign red = (state == RED);
assign yellow = (state == YELLOW);
assign green = (state == GREEN);
assign clock = cnt;

endmodule