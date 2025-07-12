module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output [5:0] clock,
    output red,
    output yellow,
    output green
);

// Parameters for timing
parameter RED_TIME = 10;
parameter YELLOW_TIME = 5;
parameter GREEN_TIME = 60;
parameter MIN_GREEN = 10;

// One-hot state encoding
localparam RED = 3'b001;
localparam YELLOW = 3'b010;
localparam GREEN = 3'b100;

reg [2:0] state, next_state;
reg [5:0] cnt;

// Combinational next state and output logic
always @(*) begin
    next_state = state;
    
    if (cnt == 0) begin
        case (state)
            RED:    next_state = GREEN;
            YELLOW: next_state = RED;
            GREEN:  next_state = YELLOW;
            default: next_state = RED;
        endcase
    end

    // Handle pedestrian request
    if (pass_request && (state == GREEN) && (cnt > MIN_GREEN)) begin
        cnt = MIN_GREEN;
    end
end

// Sequential logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= RED;
        cnt <= RED_TIME;
    end else begin
        state <= next_state;
        
        if (cnt == 0) begin
            case (next_state)
                RED:    cnt <= RED_TIME;
                YELLOW: cnt <= YELLOW_TIME;
                GREEN:  cnt <= GREEN_TIME;
                default: cnt <= RED_TIME;
            endcase
        end else begin
            cnt <= cnt - 1;
        end
    end
end

// Output assignments
assign red = (state == RED);
assign yellow = (state == YELLOW);
assign green = (state == GREEN);
assign clock = cnt;

endmodule