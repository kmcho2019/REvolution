module traffic_light (
    input        rst_n,
    input        clk,
    input        pass_request,
    output reg [7:0] clock,
    output       red,
    output       yellow,
    output       green
);

    // Timing parameters
    localparam RED_TIME     = 8'd10;
    localparam YELLOW_TIME  = 8'd5;
    localparam GREEN_TIME   = 8'd60;
    localparam GREEN_SHORT  = 8'd10;

    // States
    typedef enum logic [1:0] {
        IDLE   = 2'd0,
        RED_S  = 2'd1,
        YELLOW = 2'd2,
        GREEN  = 2'd3
    } state_t;

    state_t state, next_state;
    reg [7:0] cnt, next_cnt;

    // State and counter synchronous update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            cnt   <= 8'd0;
        end else begin
            state <= next_state;
            cnt   <= next_cnt;
        end
    end

    // Next state and counter logic
    always @(*) begin
        next_state = state;
        next_cnt = cnt;

        case(state)
            IDLE: begin
                next_state = RED_S;
                next_cnt = RED_TIME;
            end
            RED_S: begin
                if (cnt == 0) begin
                    next_state = GREEN;
                    next_cnt = GREEN_TIME;
                end else begin
                    next_cnt = cnt - 1;
                end
            end
            GREEN: begin
                if (cnt == 0) begin
                    next_state = YELLOW;
                    next_cnt = YELLOW_TIME;
                end else begin
                    // If pass_request and time left > 10, shorten to 10
                    if (pass_request && cnt > GREEN_SHORT)
                        next_cnt = GREEN_SHORT;
                    else
                        next_cnt = cnt - 1;
                end
            end
            YELLOW: begin
                if (cnt == 0) begin
                    next_state = RED_S;
                    next_cnt = RED_TIME;
                end else begin
                    next_cnt = cnt - 1;
                end
            end
            default: begin
                next_state = RED_S;
                next_cnt = RED_TIME;
            end
        endcase
    end

    // Outputs derived combinationally
    assign red    = (state == RED_S);
    assign yellow = (state == YELLOW);
    assign green  = (state == GREEN);

    // Output the current counter value
    always @(*) begin
        clock = cnt;
    end

endmodule