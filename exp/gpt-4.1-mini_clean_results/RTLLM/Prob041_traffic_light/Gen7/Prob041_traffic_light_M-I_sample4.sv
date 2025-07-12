module traffic_light (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       pass_request,
    output reg [7:0]  clock,
    output reg        red,
    output reg        yellow,
    output reg        green
);

// One-hot state encoding for simpler decoding and less LUT usage
localparam RED    = 3'b001;
localparam GREEN  = 3'b010;
localparam YELLOW = 3'b100;

// Timing parameters
localparam RED_TIME    = 8'd10;
localparam YELLOW_TIME = 8'd5;
localparam GREEN_TIME  = 8'd60;
localparam SHORT_GREEN = 8'd10;

reg [2:0] state, next_state;
reg [7:0] timer, next_timer;

// Combinational next state logic: move to next state when timer reaches zero
always @(*) begin
    case (state)
        RED:    next_state = (timer == 8'd0) ? GREEN  : RED;
        GREEN:  next_state = (timer == 8'd0) ? YELLOW : GREEN;
        YELLOW: next_state = (timer == 8'd0) ? RED    : YELLOW;
        default: next_state = RED;
    endcase
end

// Helper to compute shortened green timer if pass_request asserted
function [7:0] shorten_green;
    input [7:0] curr_timer;
    input       pass_req;
    begin
        if (pass_req && (curr_timer > SHORT_GREEN))
            shorten_green = SHORT_GREEN;
        else
            shorten_green = curr_timer;
    end
endfunction

// Combinational next timer logic with clock gating concept: only update timer if needed
always @(*) begin
    if (state != next_state) begin
        // Reload timer for next state
        case (next_state)
            RED:    next_timer = RED_TIME;
            GREEN:  next_timer = GREEN_TIME;
            YELLOW: next_timer = YELLOW_TIME;
            default: next_timer = RED_TIME;
        endcase
    end else begin
        // Same state, update timer
        if (timer == 8'd0) begin
            // Hold zero until state change
            next_timer = 8'd0;
        end else begin
            case (state)
                GREEN: begin
                    // Clamp timer if pass_request asserted and timer > SHORT_GREEN
                    next_timer = shorten_green(timer - 1, pass_request);
                end
                RED, YELLOW: begin
                    // Normal decrement
                    next_timer = timer - 1;
                end
                default: next_timer = timer - 1;
            endcase
        end
    end
end

// Sequential logic with synchronous reset: update state and timer
always @(posedge clk) begin
    if (!rst_n) begin
        state <= RED;
        timer <= RED_TIME;
    end else begin
        state <= next_state;
        timer <= next_timer;
    end
end

// Outputs derived combinationally from one-hot state
always @(*) begin
    red    = state[0];
    green  = state[1];
    yellow = state[2];
    clock  = timer;
end

endmodule