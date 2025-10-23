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
localparam GREEN_TIME = 60;
localparam YELLOW_TIME = 5;
localparam RED_TIME = 10;
localparam MIN_GREEN = 10;

// State encoding
reg [1:0] current_state, next_state;
reg [5:0] cnt;

// State definitions
localparam RED    = 2'b00;
localparam YELLOW = 2'b01;
localparam GREEN  = 2'b10;

// State transition logic (combinational)
always @(*) begin
    next_state = current_state;
    if (cnt == 0) begin
        case (current_state)
            RED:    next_state = GREEN;
            YELLOW: next_state = RED;
            GREEN:  next_state = YELLOW;
        endcase
    end
end

// Counter and state register (sequential)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= RED;
        cnt <= RED_TIME;
    end else begin
        current_state <= next_state;
        
        if (cnt == 0) begin
            case (next_state)
                RED:    cnt <= RED_TIME;
                YELLOW: cnt <= YELLOW_TIME;
                GREEN:  cnt <= GREEN_TIME;
            endcase
        end else if (current_state == GREEN && pass_request && cnt > MIN_GREEN) begin
            cnt <= MIN_GREEN;
        end else begin
            cnt <= cnt - 1;
        end
    end
end

// Output assignments
assign clock = cnt;
assign red = (current_state == RED);
assign yellow = (current_state == YELLOW);
assign green = (current_state == GREEN);

endmodule