module traffic_light (
    input        rst_n,
    input        clk,
    input        pass_request,
    output reg [7:0] clock,
    output       red,
    output       yellow,
    output       green
);

    // State encoding
    localparam [1:0]
        IDLE   = 2'd0,
        RED    = 2'd1,
        YELLOW = 2'd2,
        GREEN  = 2'd3;

    // Timing parameters
    localparam [7:0]
        RED_TIME    = 8'd10,
        YELLOW_TIME = 8'd5,
        GREEN_TIME  = 8'd60,
        GREEN_SHORT = 8'd10;

    reg [1:0] state, next_state;
    reg [7:0] cnt, next_cnt;

    // State transition logic (Moore FSM)
    always @(*) begin
        // Default assignments
        next_state = state;
        next_cnt   = cnt;

        case (state)
            IDLE: begin
                // Immediate transition to RED state
                next_state = RED;
                next_cnt = RED_TIME;
            end

            RED: begin
                if (cnt == 0) begin
                    next_state = GREEN;
                    next_cnt = GREEN_TIME;
                end else begin
                    next_cnt = cnt - 1;
                end
            end

            YELLOW: begin
                if (cnt == 0) begin
                    next_state = RED;
                    next_cnt = RED_TIME;
                end else begin
                    next_cnt = cnt - 1;
                end
            end

            GREEN: begin
                if (cnt == 0) begin
                    next_state = YELLOW;
                    next_cnt = YELLOW_TIME;
                end else begin
                    // Shorten green time if pass_request and more than GREEN_SHORT remain
                    if (pass_request && (cnt > GREEN_SHORT))
                        next_cnt = GREEN_SHORT;
                    else
                        next_cnt = cnt - 1;
                end
            end

            default: begin
                next_state = IDLE;
                next_cnt = 8'd0;
            end
        endcase
    end

    // State and counter registers update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            cnt   <= 8'd0;
        end else begin
            state <= next_state;
            cnt   <= next_cnt;
        end
    end

    // Output logic: Moore outputs depend on state
    assign red    = (state == RED);
    assign yellow = (state == YELLOW);
    assign green  = (state == GREEN);

    // Output the counter value for observation/debug
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clock <= 8'd0;
        else
            clock <= cnt;
    end

endmodule