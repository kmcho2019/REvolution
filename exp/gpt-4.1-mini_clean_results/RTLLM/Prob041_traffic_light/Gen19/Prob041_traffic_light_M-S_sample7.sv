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
    localparam [1:0]
        IDLE    = 2'b00,
        S1_RED  = 2'b01,
        S2_YELLOW = 2'b10,
        S3_GREEN = 2'b11;

    localparam [7:0]
        RED_TIME    = 8'd10,
        YELLOW_TIME = 8'd5,
        GREEN_TIME  = 8'd60,
        SHORT_GREEN = 8'd10;

    reg [1:0] state, next_state;
    reg [7:0] cnt, next_cnt;

    // State and timer sequential update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            cnt <= 8'd10;
            red <= 1'b0;
            yellow <= 1'b0;
            green <= 1'b0;
            clock <= 8'd10;
        end else begin
            state <= next_state;
            cnt <= next_cnt;
            clock <= next_cnt;

            // Outputs follow state
            red <= (next_state == S1_RED);
            yellow <= (next_state == S2_YELLOW);
            green <= (next_state == S3_GREEN);
        end
    end

    // Next state and timer logic
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
                end else begin
                    next_cnt = cnt - 1;
                end
            end

            S3_GREEN: begin
                if (pass_request && cnt > SHORT_GREEN) begin
                    next_cnt = SHORT_GREEN;  // Shorten green if needed
                end else if (cnt == 0) begin
                    next_state = S2_YELLOW;
                    next_cnt = YELLOW_TIME;
                end else if (cnt > 0) begin
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
                next_state = S1_RED;
                next_cnt = RED_TIME;
            end
        endcase
    end

endmodule