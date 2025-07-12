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
    localparam S2_YEL  = 2'd2;
    localparam S3_GRN  = 2'd3;

    // Timing constants (in clock cycles)
    localparam RED_TIME    = 8'd10;
    localparam YELLOW_TIME = 8'd5;
    localparam GREEN_TIME  = 8'd60;
    localparam GREEN_MIN   = 8'd10;

    reg [1:0] state, next_state;
    reg [7:0] cnt, next_cnt;

    // Timer enable signal to reduce toggling when counter is zero
    wire timer_en = (cnt != 0);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            cnt   <= 8'd0;
            clock <= 8'd0;
        end else begin
            state <= next_state;
            cnt   <= next_cnt;
            clock <= next_cnt; // output the updated count synchronously
        end
    end

    always @(*) begin
        next_state = state;
        next_cnt   = cnt;

        case (state)
            IDLE: begin
                // Immediately go to red state with red timer
                next_state = S1_RED;
                next_cnt   = RED_TIME;
            end

            S1_RED: begin
                if (timer_en) begin
                    next_cnt = cnt - 1;
                end

                if (cnt == 0) begin
                    next_state = S3_GRN;
                    next_cnt   = GREEN_TIME;
                end
            end

            S2_YEL: begin
                if (timer_en) begin
                    next_cnt = cnt - 1;
                end

                if (cnt == 0) begin
                    next_state = S1_RED;
                    next_cnt   = RED_TIME;
                end
            end

            S3_GRN: begin
                // If pedestrian request active and remaining green > GREEN_MIN, shorten to GREEN_MIN
                if (pass_request && (cnt > GREEN_MIN)) begin
                    next_cnt = GREEN_MIN;
                end else if (timer_en) begin
                    next_cnt = cnt - 1;
                end

                if (cnt == 0) begin
                    next_state = S2_YEL;
                    next_cnt   = YELLOW_TIME;
                end
            end

            default: begin
                next_state = IDLE;
                next_cnt   = 8'd0;
            end
        endcase
    end

    // Outputs derived combinationally from current state
    assign red    = (state == S1_RED);
    assign yellow = (state == S2_YEL);
    assign green  = (state == S3_GRN);

endmodule