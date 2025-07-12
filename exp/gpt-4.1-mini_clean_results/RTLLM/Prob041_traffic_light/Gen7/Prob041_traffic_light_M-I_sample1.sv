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
reg       timer_en;

// Combinational next state logic: transition when timer reaches zero
always @(*) begin
    case (state)
        RED:    next_state = (timer == 8'd0) ? GREEN  : RED;
        GREEN:  next_state = (timer == 8'd0) ? YELLOW : GREEN;
        YELLOW: next_state = (timer == 8'd0) ? RED    : YELLOW;
        default: next_state = RED;
    endcase
end

// Combinational next timer logic and timer enable signal
always @(*) begin
    if (state != next_state) begin
        // On state transition, reload timer according to next state
        case (next_state)
            RED:    next_timer = RED_TIME;
            GREEN:  next_timer = GREEN_TIME;
            YELLOW: next_timer = YELLOW_TIME;
            default: next_timer = RED_TIME;
        endcase
        timer_en = 1'b1; // enable timer loading
    end else begin
        // Same state
        case (state)
            GREEN: begin
                if (pass_request && (timer > SHORT_GREEN)) begin
                    next_timer = SHORT_GREEN;
                    timer_en = 1'b1;
                end else if (timer != 8'd0) begin
                    next_timer = timer - 1;
                    timer_en = 1'b1;
                end else begin
                    next_timer = 8'd0;
                    timer_en = 1'b0; // stop decrementing timer at zero
                end
            end
            RED, YELLOW: begin
                if (timer != 8'd0) begin
                    next_timer = timer - 1;
                    timer_en = 1'b1;
                end else begin
                    next_timer = 8'd0;
                    timer_en = 1'b0;
                end
            end
            default: begin
                next_timer = RED_TIME;
                timer_en = 1'b1;
            end
        endcase
    end
end

// Sequential logic: synchronous reset, state and timer update on clock edge
always @(posedge clk) begin
    if (!rst_n) begin
        state <= RED;
        timer <= RED_TIME;
    end else begin
        state <= next_state;
        // Update timer only when enabled to reduce toggle
        if (timer_en)
            timer <= next_timer;
        else
            timer <= timer;
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