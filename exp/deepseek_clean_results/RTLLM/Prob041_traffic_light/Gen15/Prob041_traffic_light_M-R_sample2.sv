module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output reg [5:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

// Timing parameters
localparam GREEN_DURATION = 60;
localparam YELLOW_DURATION = 5;
localparam RED_DURATION = 10;
localparam MIN_GREEN_REMAINING = 10;

// One-hot state encoding
localparam RED_STATE    = 3'b001;
localparam YELLOW_STATE = 3'b010;
localparam GREEN_STATE  = 3'b100;
reg [2:0] state, next_state;

// Counter and pedestrian logic
reg [5:0] next_cnt;
wire pedestrian_override;

// Pedestrian request handling
assign pedestrian_override = pass_request && (state == GREEN_STATE) && (clock > MIN_GREEN_REMAINING);

// Next state logic
always @(*) begin
    case (state)
        RED_STATE:    next_state = (clock == 0) ? GREEN_STATE : RED_STATE;
        YELLOW_STATE: next_state = (clock == 0) ? RED_STATE : YELLOW_STATE;
        GREEN_STATE:  next_state = (clock == 0) ? YELLOW_STATE : GREEN_STATE;
        default:     next_state = RED_STATE;
    endcase
end

// Counter logic
always @(*) begin
    if (pedestrian_override)
        next_cnt = MIN_GREEN_REMAINING;
    else if (clock == 0) begin
        case (next_state)
            RED_STATE:    next_cnt = RED_DURATION;
            YELLOW_STATE: next_cnt = YELLOW_DURATION;
            GREEN_STATE:  next_cnt = GREEN_DURATION;
            default:      next_cnt = RED_DURATION;
        endcase
    end else
        next_cnt = clock - 1;
end

// Sequential logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= RED_STATE;
        clock <= RED_DURATION;
        red <= 1'b1;
        yellow <= 1'b0;
        green <= 1'b0;
    end else begin
        state <= next_state;
        clock <= next_cnt;
        
        // Registered outputs
        red <= (next_state == RED_STATE);
        yellow <= (next_state == YELLOW_STATE);
        green <= (next_state == GREEN_STATE);
    end
end

endmodule