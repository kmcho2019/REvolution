module traffic_light (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       pass_request,
    output reg [6:0]  clock,
    output reg        red,
    output reg        yellow,
    output reg        green
);

// State encoding
localparam IDLE   = 2'd0; // Not used as per original, but defined for clarity
localparam RED    = 2'd1;
localparam YELLOW = 2'd2;
localparam GREEN  = 2'd3;

// Timer constants
localparam RED_TIME    = 7'd10;
localparam YELLOW_TIME = 7'd5;
localparam GREEN_TIME  = 7'd60;
localparam SHORT_GREEN = 7'd10;

reg [1:0] state, next_state;
reg [6:0] timer, next_timer;

// Timer enable signal to reduce toggling when timer is zero
wire timer_en = (timer != 0);

// Determine if pedestrian shortening should be applied
wire apply_shortening = (state == GREEN) && pass_request && (timer > SHORT_GREEN);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= RED;
        timer <= RED_TIME;
    end else begin
        state <= next_state;
        timer <= next_timer;
    end
end

always @(*) begin
    next_state = state;
    next_timer = timer;

    if (timer_en) begin
        next_timer = timer - 1;
    end

    case(state)
        RED: begin
            if (timer == 0) begin
                next_state = GREEN;
                next_timer = GREEN_TIME;
            end
        end
        GREEN: begin
            // If pedestrian request and time left more than SHORT_GREEN, shorten timer immediately
            if (apply_shortening) begin
                next_timer = SHORT_GREEN;
            end else if (timer == 0) begin
                next_state = YELLOW;
                next_timer = YELLOW_TIME;
            end
        end
        YELLOW: begin
            if (timer == 0) begin
                next_state = RED;
                next_timer = RED_TIME;
            end
        end
        default: begin
            next_state = RED;
            next_timer = RED_TIME;
        end
    endcase
end

// Outputs combinational from state and timer
always @(*) begin
    red    = (state == RED);
    yellow = (state == YELLOW);
    green  = (state == GREEN);
    clock  = timer;
end

endmodule