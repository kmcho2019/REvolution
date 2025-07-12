module traffic_light (
    input wire rst_n,
    input wire clk,
    input wire pass_request,
    output reg [7:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

// State encoding
localparam RED    = 2'd0;
localparam GREEN  = 2'd1;
localparam YELLOW = 2'd2;

// Durations
localparam RED_TIME    = 8'd10;
localparam YELLOW_TIME = 8'd5;
localparam GREEN_TIME  = 8'd60;
localparam SHORT_GREEN = 8'd10;

reg [1:0] state, next_state;
reg [7:0] timer, next_timer;

// State transition on timer zero
always @(*) begin
    case (state)
        RED:    next_state = (timer == 0) ? GREEN  : RED;
        GREEN:  next_state = (timer == 0) ? YELLOW : GREEN;
        YELLOW: next_state = (timer == 0) ? RED    : YELLOW;
        default: next_state = RED;
    endcase
end

// Timer update logic with pass_request shortening green once per green phase
always @(*) begin
    // Default keep timer or reload on state transition
    if (state != next_state) begin
        case (next_state)
            RED:    next_timer = RED_TIME;
            GREEN:  next_timer = GREEN_TIME;
            YELLOW: next_timer = YELLOW_TIME;
            default: next_timer = RED_TIME;
        endcase
    end else if (state == GREEN) begin
        // When pass_request is asserted and timer > SHORT_GREEN, clamp timer to SHORT_GREEN once
        // Only clamp if timer currently > SHORT_GREEN
        if (pass_request && timer > SHORT_GREEN)
            next_timer = SHORT_GREEN;
        else if (timer != 0)
            next_timer = timer - 1;
        else
            next_timer = 0; // hold zero until state changes
    end else begin
        // In RED or YELLOW states, just decrement if timer > 0
        if (timer != 0)
            next_timer = timer - 1;
        else
            next_timer = 0; // hold zero until state changes
    end
end

// Sequential state and timer update with clock enable on timer > 0
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= RED;
        timer <= RED_TIME;
    end else begin
        state <= next_state;
        timer <= next_timer;
    end
end

// Outputs driven from registered state
always @(*) begin
    red    = (state == RED);
    yellow = (state == YELLOW);
    green  = (state == GREEN);
    clock  = timer;
end

endmodule