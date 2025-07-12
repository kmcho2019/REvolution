module traffic_light(
    input  wire       rst_n,
    input  wire       clk,
    input  wire       pass_request,
    output reg [7:0]  clock,
    output reg        red,
    output reg        yellow,
    output reg        green
);

// State encoding with parameters
localparam [1:0]
    IDLE   = 2'd0,
    RED    = 2'd1,
    GREEN  = 2'd2,
    YELLOW = 2'd3;

// Timing constants
localparam [7:0]
    RED_TIME    = 8'd10,
    YELLOW_TIME = 8'd5,
    GREEN_TIME  = 8'd60,
    MIN_GREEN   = 8'd10;

reg [1:0] state, next_state;
reg [7:0] timer, next_timer;

// State and timer sequential update
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        timer <= 8'd0;
    end else begin
        state <= next_state;
        timer <= next_timer;
    end
end

// Next state and timer logic
always @(*) begin
    // Defaults
    next_state = state;
    next_timer = timer;

    case(state)
        IDLE: begin
            // Immediately go to RED with RED_TIME
            next_state = RED;
            next_timer = RED_TIME;
        end

        RED: begin
            if (timer == 0) begin
                next_state = GREEN;
                next_timer = GREEN_TIME;
            end else begin
                next_timer = timer - 1;
            end
        end

        GREEN: begin
            if (timer == 0) begin
                next_state = YELLOW;
                next_timer = YELLOW_TIME;
            end else if (pass_request && (timer > MIN_GREEN)) begin
                // Shorten green to MIN_GREEN if pass_request and time left > 10
                next_timer = MIN_GREEN;
            end else begin
                next_timer = timer - 1;
            end
        end

        YELLOW: begin
            if (timer == 0) begin
                next_state = RED;
                next_timer = RED_TIME;
            end else begin
                next_timer = timer - 1;
            end
        end

        default: begin
            next_state = IDLE;
            next_timer = 8'd0;
        end
    endcase
end

// Output logic purely combinational from state
always @(*) begin
    red    = (state == RED);
    yellow = (state == YELLOW);
    green  = (state == GREEN);
    clock  = timer;
end

endmodule