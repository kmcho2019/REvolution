module traffic_light (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       pass_request,
    output reg  [7:0] clock,
    output wire       red,
    output wire       yellow,
    output wire       green
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

    // Combinational next-state logic without decrementing timer
    always @(*) begin
        next_state = state;
        next_timer = timer; // default hold

        case(state)
            IDLE: begin
                // Immediately start red with RED_TIME
                next_state = S1_RED;
                next_timer = RED_TIME;
            end

            S1_RED: begin
                if (timer == 0) begin
                    next_state = S3_GREEN;
                    next_timer = GREEN_TIME;
                end
            end

            S2_YELLOW: begin
                if (timer == 0) begin
                    next_state = S1_RED;
                    next_timer = RED_TIME;
                end
            end

            S3_GREEN: begin
                if (timer == 0) begin
                    next_state = S2_YELLOW;
                    next_timer = YELLOW_TIME;
                end
            end

            default: begin
                next_state = IDLE;
                next_timer = 0;
            end
        endcase
    end

    // Sequential logic: update state and timer, decrement timer when enabled
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            timer <= 0;
        end else begin
            state <= next_state;
            // Timer reload or decrement logic
            if (state != next_state) begin
                // State changed, load new timer value
                timer <= next_timer;
            end else if (state == S3_GREEN && pass_request && timer > GREEN_MIN) begin
                // Pedestrian request shortens green time to GREEN_MIN if longer
                timer <= GREEN_MIN;
            end else if (timer != 0) begin
                // Normal timer countdown
                timer <= timer - 1;
            end
            // else timer stays at 0
        end
    end

    // Outputs driven combinationally from state
    assign red    = (state == S1_RED);
    assign yellow = (state == S2_YELLOW);
    assign green  = (state == S3_GREEN);

    // Output clock = timer value
    always @(*) begin
        clock = timer;
    end

endmodule