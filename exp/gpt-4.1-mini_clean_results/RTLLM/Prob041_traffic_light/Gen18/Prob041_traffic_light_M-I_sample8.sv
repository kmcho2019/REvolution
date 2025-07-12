module traffic_light (
    input        rst_n,
    input        clk,
    input        pass_request,
    output reg [7:0] clock,
    output       red,
    output       yellow,
    output       green
);

    // Timing parameters (7 bits sufficient, extended output to 8 bits as specified)
    localparam [7:0] RED_TIME     = 8'd10;
    localparam [7:0] YELLOW_TIME  = 8'd5;
    localparam [7:0] GREEN_TIME   = 8'd60;
    localparam [7:0] GREEN_SHORT  = 8'd10;

    // State encoding
    typedef enum reg [1:0] {
        IDLE    = 2'd0,
        S1_RED  = 2'd1,
        S2_YELLOW = 2'd2,
        S3_GREEN = 2'd3
    } state_t;

    reg [1:0] state, next_state;
    reg [7:0] cnt, next_cnt;

    // Remove asynchronous reset, use synchronous reset for better synthesis
    always @(posedge clk) begin
        if (!rst_n) begin
            state <= IDLE;
            cnt <= 8'd0;
        end else begin
            state <= next_state;
            cnt <= next_cnt;
        end
    end

    // Next-state and next-counter logic
    always @(*) begin
        // Defaults to hold state and decrement counter if not zero
        next_state = state;
        if (cnt != 0)
            next_cnt = cnt - 1;
        else
            next_cnt = cnt;

        case (state)
            IDLE: begin
                // Immediately transition from IDLE to S1_RED with counter set to RED_TIME
                next_state = S1_RED;
                next_cnt = RED_TIME;
            end

            S1_RED: begin
                // Stay in RED until count reaches 0, then go to GREEN
                if (cnt == 0) begin
                    next_state = S3_GREEN;
                    next_cnt = GREEN_TIME;
                end
            end

            S2_YELLOW: begin
                // Stay in YELLOW until count reaches 0, then go to RED
                if (cnt == 0) begin
                    next_state = S1_RED;
                    next_cnt = RED_TIME;
                end
            end

            S3_GREEN: begin
                // Pedestrian button shortens green phase if remaining green > 10
                if (pass_request && (cnt > GREEN_SHORT))
                    next_cnt = GREEN_SHORT;
                // On count reaching 0, move to YELLOW
                else if (cnt == 0) begin
                    next_state = S2_YELLOW;
                    next_cnt = YELLOW_TIME;
                end
            end

            default: begin
                next_state = IDLE;
                next_cnt = 8'd0;
            end
        endcase
    end

    // Outputs combinationally derived from state (Moore outputs)
    assign red    = (state == S1_RED);
    assign yellow = (state == S2_YELLOW);
    assign green  = (state == S3_GREEN);

    // Output counter value, extending cnt (7 or 8 bits) to 8 bits output
    always @(*) begin
        clock = cnt;
    end

endmodule