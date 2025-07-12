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
localparam IDLE  = 2'b00;
localparam RED   = 2'b01;
localparam YELLOW = 2'b10;
localparam GREEN = 2'b11;

reg [1:0] state, next_state;
reg [5:0] cnt;

// Output assignments
assign red = (state == RED);
assign yellow = (state == YELLOW);
assign green = (state == GREEN);
assign clock = cnt;

// Next state logic (combinational)
always @(*) begin
    case (state)
        IDLE:   next_state = RED;
        RED:    next_state = (cnt == 1) ? GREEN : RED;
        YELLOW: next_state = (cnt == 1) ? RED : YELLOW;
        GREEN:  next_state = (cnt == 1) ? YELLOW : GREEN;
        default: next_state = RED;
    endcase
end

// Sequential logic (state and counter)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= RED;
        cnt <= RED_TIME;
    end else begin
        state <= next_state;
        
        // Handle counter updates
        if (pass_request && (state == GREEN) && (cnt > MIN_GREEN)) begin
            cnt <= MIN_GREEN;
        end
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

endmodule