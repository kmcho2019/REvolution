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
    localparam IDLE     = 2'd0;
    localparam S1_RED   = 2'd1;
    localparam S2_YELLOW= 2'd2;
    localparam S3_GREEN = 2'd3;

    // Timing parameters
    localparam RED_TIME    = 8'd10;
    localparam YELLOW_TIME = 8'd5;
    localparam GREEN_TIME  = 8'd60;
    localparam GREEN_MIN   = 8'd10;

    reg [1:0] state, next_state;
    reg [7:0] timer, next_timer;

    // Sequential logic: state and timer update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            timer <= 8'd0;
            red    <= 1'b0;
            yellow <= 1'b0;
            green  <= 1'b0;
            clock  <= 8'd0;
        end else begin
            state <= next_state;
            timer <= next_timer;
            clock <= next_timer;

            // Outputs updated based on next_state for glitch reduction
            case(next_state)
                IDLE: begin
                    red    <= 1'b0;
                    yellow <= 1'b0;
                    green  <= 1'b0;
                end
                S1_RED: begin
                    red    <= 1'b1;
                    yellow <= 1'b0;
                    green  <= 1'b0;
                end
                S2_YELLOW: begin
                    red    <= 1'b0;
                    yellow <= 1'b1;
                    green  <= 1'b0;
                end
                S3_GREEN: begin
                    red    <= 1'b0;
                    yellow <= 1'b0;
                    green  <= 1'b1;
                end
                default: begin
                    red    <= 1'b0;
                    yellow <= 1'b0;
                    green  <= 1'b0;
                end
            endcase
        end
    end

    // Combinational logic: next state and timer calculation
    always @(*) begin
        next_state = state;
        next_timer = timer;

        case(state)
            IDLE: begin
                // Immediately transition to red with full red time
                next_state = S1_RED;
                next_timer = RED_TIME;
            end

            S1_RED: begin
                if (timer == 0) begin
                    next_state = S3_GREEN;
                    next_timer = GREEN_TIME;
                end else begin
                    next_timer = timer - 1;
                end
            end

            S2_YELLOW: begin
                if (timer == 0) begin
                    next_state = S1_RED;
                    next_timer = RED_TIME;
                end else begin
                    next_timer = timer - 1;
                end
            end

            S3_GREEN: begin
                // Pedestrian button shortens green to GREEN_MIN if timer > GREEN_MIN
                if (pass_request && timer > GREEN_MIN) begin
                    next_timer = GREEN_MIN;
                    next_state = S3_GREEN; // stay in green state
                end else if (timer == 0) begin
                    next_state = S2_YELLOW;
                    next_timer = YELLOW_TIME;
                end else begin
                    next_timer = timer - 1;
                end
            end

            default: begin
                next_state = IDLE;
                next_timer = 0;
            end
        endcase
    end

endmodule