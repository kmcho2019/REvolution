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
    localparam [1:0] IDLE     = 2'd0,
                     S1_RED   = 2'd1,
                     S2_YELLOW= 2'd2,
                     S3_GREEN = 2'd3;

    // Timing parameters
    localparam [7:0] RED_TIME    = 8'd10,
                     YELLOW_TIME = 8'd5,
                     GREEN_TIME  = 8'd60,
                     SHORT_GREEN = 8'd10;

    reg [1:0] state, next_state;
    reg [7:0] cnt, next_cnt;

    // State register update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Timer countdown and next state logic
    always @(*) begin
        next_state = state;
        next_cnt = cnt;

        case(state)
            IDLE: begin
                next_state = S1_RED;
                next_cnt = RED_TIME;
            end

            S1_RED: begin
                if (cnt == 0) begin
                    next_state = S3_GREEN;
                    next_cnt = GREEN_TIME;
                end else
                    next_cnt = cnt - 1;
            end

            S3_GREEN: begin
                // If pedestrian requests and remaining green time > 10, shorten to 10
                if (pass_request && cnt > SHORT_GREEN)
                    next_cnt = SHORT_GREEN;
                else if (cnt == 0) begin
                    next_state = S2_YELLOW;
                    next_cnt = YELLOW_TIME;
                end else
                    next_cnt = cnt - 1;
            end

            S2_YELLOW: begin
                if (cnt == 0) begin
                    next_state = S1_RED;
                    next_cnt = RED_TIME;
                end else
                    next_cnt = cnt - 1;
            end

            default: begin
                next_state = IDLE;
                next_cnt = 0;
            end
        endcase
    end

    // Counter register update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt <= 8'd0;
        else
            cnt <= next_cnt;
    end

    // Drive output lights directly from state (Moore outputs)
    assign red    = (state == S1_RED);
    assign yellow = (state == S2_YELLOW);
    assign green  = (state == S3_GREEN);

    // Output the current counter value synchronously
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clock <= 8'd0;
        else
            clock <= cnt;
    end

endmodule