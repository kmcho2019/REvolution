module traffic_light (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       pass_request,
    output reg  [7:0] clock,
    output reg        red,
    output reg        yellow,
    output reg        green
);

// State encoding
localparam IDLE    = 2'd0;
localparam RED     = 2'd1;
localparam GREEN   = 2'd2;
localparam YELLOW  = 2'd3;

// State durations
localparam RED_TIME    = 8'd10;
localparam YELLOW_TIME = 8'd5;
localparam GREEN_TIME  = 8'd60;
localparam SHORT_GREEN = 8'd10;

reg [1:0] state, next_state;

// Individual countdown timers for each phase
reg [7:0] red_timer, next_red_timer;
reg [7:0] yellow_timer, next_yellow_timer;
reg [7:0] green_timer, next_green_timer;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state        <= RED;
        red_timer    <= RED_TIME;
        yellow_timer <= YELLOW_TIME;
        green_timer  <= GREEN_TIME;
    end else begin
        state        <= next_state;
        red_timer    <= next_red_timer;
        yellow_timer <= next_yellow_timer;
        green_timer  <= next_green_timer;
    end
end

always @(*) begin
    // Default assignments: hold timers unless decremented or reset
    next_state        = state;

    next_red_timer    = red_timer;
    next_yellow_timer = yellow_timer;
    next_green_timer  = green_timer;

    case(state)
        RED: begin
            // Countdown red timer if >0
            if (red_timer != 0) begin
                next_red_timer = red_timer - 1;
            end

            // Transition to GREEN when red timer expires
            if (red_timer == 0) begin
                next_state       = GREEN;
                next_green_timer = GREEN_TIME;
            end
        end

        GREEN: begin
            // Pedestrian request shortening logic
            // If pass_request asserted and remaining green time > 10, shorten timer to 10
            if (pass_request && (green_timer > SHORT_GREEN)) begin
                next_green_timer = SHORT_GREEN;
            end else if (green_timer != 0) begin
                // Normal countdown
                next_green_timer = green_timer - 1;
            end

            // Transition to YELLOW when green timer expires
            if (green_timer == 0) begin
                next_state       = YELLOW;
                next_yellow_timer = YELLOW_TIME;
            end
        end

        YELLOW: begin
            // Countdown yellow timer if >0
            if (yellow_timer != 0) begin
                next_yellow_timer = yellow_timer - 1;
            end

            // Transition to RED when yellow timer expires
            if (yellow_timer == 0) begin
                next_state       = RED;
                next_red_timer   = RED_TIME;
            end
        end

        default: begin
            // Safety fallback: reset to RED state and timers
            next_state       = RED;
            next_red_timer   = RED_TIME;
            next_yellow_timer = YELLOW_TIME;
            next_green_timer = GREEN_TIME;
        end
    endcase
end

// Output logic: assign based on current state; clock outputs the corresponding timer
always @(*) begin
    red    = (state == RED);
    yellow = (state == YELLOW);
    green  = (state == GREEN);

    case(state)
        RED:    clock = red_timer;
        GREEN:  clock = green_timer;
        YELLOW: clock = yellow_timer;
        default: clock = 8'd0;
    endcase
end

endmodule