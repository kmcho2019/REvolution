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
localparam RED    = 2'd0;
localparam GREEN  = 2'd1;
localparam YELLOW = 2'd2;

// Timing constants
localparam RED_TIME    = 7'd10;
localparam YELLOW_TIME = 7'd5;
localparam GREEN_TIME  = 7'd60;
localparam SHORT_GREEN = 7'd10;

reg [1:0] state, next_state;
reg [6:0] timer, next_timer;

wire timer_active = (timer != 0);

// Single synchronous block to update state and timer
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= RED;
        timer <= RED_TIME;
    end else begin
        state <= next_state;
        timer <= next_timer;
    end
end

// Combinational logic for next state and timer
always @(*) begin
    next_state = state;
    next_timer = timer;

    case(state)
        RED: begin
            if (timer == 0) begin
                next_state = GREEN;
                next_timer = GREEN_TIME;
            end else if (timer_active) begin
                next_timer = timer - 1;
            end
        end
        GREEN: begin
            // Pedestrian request shortens green to SHORT_GREEN if remaining time > SHORT_GREEN
            if (pass_request && (timer > SHORT_GREEN)) begin
                next_timer = SHORT_GREEN;
            end else if (timer == 0) begin
                next_state = YELLOW;
                next_timer = YELLOW_TIME;
            end else if (timer_active) begin
                next_timer = timer - 1;
            end
        end
        YELLOW: begin
            if (timer == 0) begin
                next_state = RED;
                next_timer = RED_TIME;
            end else if (timer_active) begin
                next_timer = timer - 1;
            end
        end
        default: begin
            next_state = RED;
            next_timer = RED_TIME;
        end
    endcase
end

// Outputs driven combinationally from state
always @(*) begin
    red    = (state == RED);
    yellow = (state == YELLOW);
    green  = (state == GREEN);
    clock  = timer;
end

endmodule