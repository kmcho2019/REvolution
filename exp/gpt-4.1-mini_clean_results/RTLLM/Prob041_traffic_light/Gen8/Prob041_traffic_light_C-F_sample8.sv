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

    // Next state logic based on timer expiration
    always @(*) begin
        case (state)
            RED:    next_state = (timer == 0) ? GREEN  : RED;
            GREEN:  next_state = (timer == 0) ? YELLOW : GREEN;
            YELLOW: next_state = (timer == 0) ? RED    : YELLOW;
            default: next_state = RED;
        endcase
    end

    // Next timer logic with pass_request shortening of green duration once
    always @(*) begin
        if (state != next_state) begin
            // Reload timer for new state
            case (next_state)
                RED:    next_timer = RED_TIME;
                GREEN:  next_timer = GREEN_TIME;
                YELLOW: next_timer = YELLOW_TIME;
                default: next_timer = RED_TIME;
            endcase
        end else begin
            // Within same state: decrement timer or clamp green timer on pass_request
            if (timer == 0) begin
                next_timer = 0;
            end else if (state == GREEN) begin
                // Clamp timer to SHORT_GREEN if pass_request asserted and timer > SHORT_GREEN
                if (pass_request && timer > SHORT_GREEN)
                    next_timer = SHORT_GREEN;
                else
                    next_timer = timer - 1;
            end else begin
                // For RED and YELLOW, just decrement timer if > 0
                next_timer = timer - 1;
            end
        end
    end

    // Sequential state and timer update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= RED;
            timer <= RED_TIME;
        end else begin
            state <= next_state;
            timer <= next_timer;
        end
    end

    // Outputs driven combinationally from registered state and timer
    always @(*) begin
        red    = (state == RED);
        yellow = (state == YELLOW);
        green  = (state == GREEN);
        clock  = timer;
    end

endmodule