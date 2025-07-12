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

    // State and next-state logic (combinational)
    always @(*) begin
        next_state = state;
        next_timer = timer;

        case(state)
            IDLE: begin
                // Immediately go to RED with RED_TIME count
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
                // Pedestrian button shortens green if time > GREEN_MIN
                if (pass_request && (timer > GREEN_MIN)) begin
                    next_timer = GREEN_MIN;
                end
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

    wire timer_en = (timer != 0);

    // Sequential logic: state and timer update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            timer <= 0;
        end else begin
            state <= next_state;
            // Decrement timer only when enabled and not reset by next_timer update
            if (timer_en) begin
                if (next_timer != timer)
                    timer <= next_timer; // Forced update, e.g. reset or shorten
                else
                    timer <= timer - 1;
            end else begin
                timer <= next_timer; // load new timer value at state change or init
            end
        end
    end

    // Output logic from state (combinational)
    assign red    = (state == S1_RED);
    assign yellow = (state == S2_YELLOW);
    assign green  = (state == S3_GREEN);

    // Clock output from timer
    always @(*) begin
        clock = timer;
    end

endmodule