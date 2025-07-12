module traffic_light (
    input          rst_n,
    input          clk,
    input          pass_request,
    output reg [7:0] clock,
    output         red,
    output         yellow,
    output         green
);

    // Timing parameters
    localparam [7:0] RED_TIME     = 8'd10;
    localparam [7:0] YELLOW_TIME  = 8'd5;
    localparam [7:0] GREEN_TIME   = 8'd60;
    localparam [7:0] GREEN_SHORT  = 8'd10;

    // State encoding
    typedef enum logic [1:0] {
        S_RED    = 2'd0,
        S_GREEN  = 2'd1,
        S_YELLOW = 2'd2
    } state_t;

    state_t state, next_state;
    reg [7:0] cnt, next_cnt;

    // Next state and counter logic - combinational
    always @(*) begin
        next_state = state;
        next_cnt   = cnt;

        case(state)
            S_RED: begin
                if (cnt == 0) begin
                    next_state = S_GREEN;
                    next_cnt = GREEN_TIME;
                end else
                    next_cnt = cnt - 1;
            end

            S_GREEN: begin
                if (pass_request && (cnt > GREEN_SHORT))
                    next_cnt = GREEN_SHORT;
                else if (cnt == 0) begin
                    next_state = S_YELLOW;
                    next_cnt = YELLOW_TIME;
                end else
                    next_cnt = cnt - 1;
            end

            S_YELLOW: begin
                if (cnt == 0) begin
                    next_state = S_RED;
                    next_cnt = RED_TIME;
                end else
                    next_cnt = cnt - 1;
            end

            default: begin
                next_state = S_RED;
                next_cnt = RED_TIME;
            end
        endcase
    end

    // State and counter update - synchronous
    always @(posedge clk) begin
        if (!rst_n) begin
            state <= S_RED;
            cnt <= RED_TIME;
        end else begin
            state <= next_state;
            cnt <= next_cnt;
        end
    end

    // Output assignments from state - combinational
    assign red    = (state == S_RED);
    assign yellow = (state == S_YELLOW);
    assign green  = (state == S_GREEN);

    // Output clock is current counter value
    always @(*) begin
        clock = cnt;
    end

endmodule