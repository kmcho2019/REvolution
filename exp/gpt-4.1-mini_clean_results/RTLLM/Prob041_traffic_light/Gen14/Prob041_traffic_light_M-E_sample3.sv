module traffic_light (
    input        rst_n,
    input        clk,
    input        pass_request,
    output reg [7:0] clock,
    output reg   red,
    output reg   yellow,
    output reg   green
);

    // State encoding
    localparam [1:0]
        IDLE     = 2'b00,
        S1_RED   = 2'b01,
        S2_YELLOW= 2'b10,
        S3_GREEN = 2'b11;

    // Timing constants
    localparam [7:0]
        RED_TIME    = 8'd10,
        YELLOW_TIME = 8'd5,
        GREEN_TIME  = 8'd60,
        GREEN_MIN   = 8'd10;

    reg [1:0] state, next_state;
    reg [7:0] cnt, next_cnt;

    // Previous outputs to hold red/yellow/green (p_red, p_yellow, p_green)
    reg p_red, p_yellow, p_green;

    // State and counter register update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state   <= IDLE;
            cnt     <= 8'd0;
            p_red   <= 1'b0;
            p_yellow<= 1'b0;
            p_green <= 1'b0;
        end else begin
            state <= next_state;
            cnt   <= next_cnt;
            // Latch outputs based on next_state
            case (next_state)
                S1_RED: begin
                    p_red    <= 1'b1;
                    p_yellow <= 1'b0;
                    p_green  <= 1'b0;
                end
                S2_YELLOW: begin
                    p_red    <= 1'b0;
                    p_yellow <= 1'b1;
                    p_green  <= 1'b0;
                end
                S3_GREEN: begin
                    p_red    <= 1'b0;
                    p_yellow <= 1'b0;
                    p_green  <= 1'b1;
                end
                default: begin
                    p_red    <= 1'b0;
                    p_yellow <= 1'b0;
                    p_green  <= 1'b0;
                end
            endcase
        end
    end

    // Next state and counter combinational logic
    always @(*) begin
        next_state = state;
        next_cnt   = cnt;

        case (state)
            IDLE: begin
                // Immediately move to red with RED_TIME
                next_state = S1_RED;
                next_cnt   = RED_TIME;
            end

            S1_RED: begin
                if (cnt == 8'd0) begin
                    next_state = S3_GREEN;
                    next_cnt   = GREEN_TIME;
                end else begin
                    next_cnt = cnt - 8'd1;
                end
            end

            S2_YELLOW: begin
                if (cnt == 8'd0) begin
                    next_state = S1_RED;
                    next_cnt   = RED_TIME;
                end else begin
                    next_cnt = cnt - 8'd1;
                end
            end

            S3_GREEN: begin
                if (pass_request && cnt > GREEN_MIN) begin
                    // Shorten green to GREEN_MIN if still longer
                    next_cnt = GREEN_MIN;
                end else if (cnt == 8'd0) begin
                    next_state = S2_YELLOW;
                    next_cnt   = YELLOW_TIME;
                end else begin
                    next_cnt = cnt - 8'd1;
                end
            end

            default: begin
                next_state = IDLE;
                next_cnt   = 8'd0;
            end
        endcase
    end

    // Output assignments: register outputs updated every clock
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            red    <= 1'b0;
            yellow <= 1'b0;
            green  <= 1'b0;
            clock  <= 8'd0;
        end else begin
            red    <= p_red;
            yellow <= p_yellow;
            green  <= p_green;
            clock  <= cnt;
        end
    end

endmodule