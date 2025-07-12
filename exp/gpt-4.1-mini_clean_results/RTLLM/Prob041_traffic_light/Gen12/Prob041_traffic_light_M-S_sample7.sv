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
    localparam IDLE    = 2'd0;
    localparam S1_RED  = 2'd1;
    localparam S2_YELLOW= 2'd2;
    localparam S3_GREEN= 2'd3;

    // Timing constants
    localparam RED_TIME    = 8'd10;
    localparam YELLOW_TIME = 8'd5;
    localparam GREEN_TIME  = 8'd60;
    localparam SHORT_GREEN = 8'd10;

    reg [1:0] state, next_state;
    reg [7:0] cnt, next_cnt;

    // State and counter update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            cnt <= 8'd0;
        end else begin
            state <= next_state;
            cnt <= next_cnt;
        end
    end

    // Next state and counter logic
    always @(*) begin
        next_state = state;
        next_cnt = cnt;

        case (state)
            IDLE: begin
                next_state = S1_RED;
                next_cnt = RED_TIME;
            end

            S1_RED: begin
                if (cnt == 0) begin
                    next_state = S3_GREEN;
                    next_cnt = GREEN_TIME;
                end else begin
                    next_cnt = cnt - 1;
                end
            end

            S3_GREEN: begin
                // Shorten green time if pass_request and remaining > 10
                if (pass_request && (cnt > SHORT_GREEN))
                    next_cnt = SHORT_GREEN;
                else if (cnt == 0) begin
                    next_state = S2_YELLOW;
                    next_cnt = YELLOW_TIME;
                end else begin
                    next_cnt = cnt - 1;
                end
            end

            S2_YELLOW: begin
                if (cnt == 0) begin
                    next_state = S1_RED;
                    next_cnt = RED_TIME;
                end else begin
                    next_cnt = cnt - 1;
                end
            end

            default: begin
                next_state = IDLE;
                next_cnt = 0;
            end
        endcase
    end

    // Output assignments
    assign red    = (state == S1_RED);
    assign yellow = (state == S2_YELLOW);
    assign green  = (state == S3_GREEN);
    always @(*) clock = cnt;

endmodule