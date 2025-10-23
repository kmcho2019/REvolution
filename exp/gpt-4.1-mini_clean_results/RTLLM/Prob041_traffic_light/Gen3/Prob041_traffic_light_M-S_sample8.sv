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
reg shortened_flag; // indicates if green time was shortened in current green phase

// State and timer update
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= RED;
        timer <= RED_TIME;
        shortened_flag <= 1'b0;
    end else begin
        state <= next_state;
        timer <= next_timer;
        if (state != GREEN)
            shortened_flag <= 1'b0;
        else if (pass_request && !shortened_flag && timer > SHORT_GREEN)
            shortened_flag <= 1'b1;
    end
end

// Next state and timer logic
always @(*) begin
    next_state = state;
    if (timer == 0) begin
        case(state)
            RED:    next_state = GREEN;
            GREEN:  next_state = YELLOW;
            YELLOW: next_state = RED;
            default: next_state = RED;
        endcase
    end

    case(state)
        RED:    next_timer = (timer == 0) ? GREEN_TIME : timer - 1;
        YELLOW: next_timer = (timer == 0) ? RED_TIME : timer - 1;
        GREEN: begin
            if (pass_request && !shortened_flag && timer > SHORT_GREEN)
                next_timer = SHORT_GREEN;
            else
                next_timer = (timer == 0) ? YELLOW_TIME : timer - 1;
        end
        default: next_timer = RED_TIME;
    endcase
end

// Outputs based on state
always @(*) begin
    red = (state == RED);
    yellow = (state == YELLOW);
    green = (state == GREEN);
    clock = timer;
end

endmodule