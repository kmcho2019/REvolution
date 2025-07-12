module traffic_light (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       pass_request,
    output reg  [7:0] clock,
    output wire       red,
    output wire       yellow,
    output wire       green
);

    // State encoding as per problem
    localparam IDLE    = 2'd0;
    localparam S1_RED  = 2'd1;
    localparam S2_YELLOW = 2'd2;
    localparam S3_GREEN = 2'd3;

    // Timing parameters
    localparam RED_TIME    = 8'd10;
    localparam YELLOW_TIME = 8'd5;
    localparam GREEN_TIME  = 8'd60;
    localparam GREEN_MIN   = 8'd10;

    reg [1:0] state;
    reg [7:0] timer;

    wire timer_en = (timer != 0);

    // Next-state and timer logic combinational
    reg [1:0] next_state;
    reg [7:0] next_timer;

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
                // Pedestrian button shortens green if time > 10
                if (pass_request && timer > GREEN_MIN) begin
                    next_timer = GREEN_MIN;
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

    // Sequential state and timer update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            timer <= 0;
        end else begin
            state <= next_state;
            timer <= next_timer;
        end
    end

    // Output logic combinational from current state
    assign red    = (state == S1_RED);
    assign yellow = (state == S2_YELLOW);
    assign green  = (state == S3_GREEN);

    // Clock output is current timer
    always @(*) begin
        clock = timer;
    end

endmodule