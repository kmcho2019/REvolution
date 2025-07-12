module traffic_light (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       pass_request,
    output reg [7:0]  clock,
    output reg        red,
    output reg        yellow,
    output reg        green
);

// State encoding
localparam RED    = 2'd0;
localparam GREEN  = 2'd1;
localparam YELLOW = 2'd2;

// Timing parameters
localparam RED_TIME    = 8'd10;
localparam YELLOW_TIME = 8'd5;
localparam GREEN_TIME  = 8'd60;
localparam SHORT_GREEN = 8'd10;

reg [1:0] state, next_state;
reg [7:0] timer, next_timer;

// Combinational next state logic: transition when timer reaches zero
always @(*) begin
    case (state)
        RED:    next_state = (timer == 8'd0) ? GREEN  : RED;
        GREEN:  next_state = (timer == 8'd0) ? YELLOW : GREEN;
        YELLOW: next_state = (timer == 8'd0) ? RED    : YELLOW;
        default: next_state = RED;
    endcase
end

// Combinational next timer logic
// On state change, reload timer with full duration.
// Otherwise, if in GREEN and pass_request asserted and timer > SHORT_GREEN,
// clamp timer down to SHORT_GREEN (shorten green time), else count down normally.
// For RED and YELLOW states, simply count down timer.
always @(*) begin
    if (state != next_state) begin
        // On state transition, reload timer according to next state
        case (next_state)
            RED:    next_timer = RED_TIME;
            GREEN:  next_timer = GREEN_TIME;
            YELLOW: next_timer = YELLOW_TIME;
            default: next_timer = RED_TIME;
        endcase
    end else begin
        // Same state, decrement timer or clamp green timer if pass_request
        case (state)
            GREEN: begin
                if (pass_request && (timer > SHORT_GREEN))
                    next_timer = SHORT_GREEN;
                else if (timer != 8'd0)
                    next_timer = timer - 1;
                else
                    next_timer = 8'd0; // Hold zero until state changes
            end
            RED, YELLOW: begin
                if (timer != 8'd0)
                    next_timer = timer - 1;
                else
                    next_timer = 8'd0;
            end
            default: next_timer = RED_TIME;
        endcase
    end
end

// Sequential logic: state and timer update on clock edge with asynchronous reset
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= RED;
        timer <= RED_TIME;
    end else begin
        state <= next_state;
        timer <= next_timer;
    end
end

// Outputs combinationally driven by registered state and timer
always @(*) begin
    red    = (state == RED);
    yellow = (state == YELLOW);
    green  = (state == GREEN);
    clock  = timer;
end

endmodule