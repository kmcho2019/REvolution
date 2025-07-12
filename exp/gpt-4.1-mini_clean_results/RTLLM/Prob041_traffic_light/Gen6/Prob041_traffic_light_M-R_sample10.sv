module traffic_light (
    input        rst_n,
    input        clk,
    input        pass_request,
    output [7:0] clock,
    output       red,
    output       yellow,
    output       green
);

    localparam RED_TIME    = 8'd10;
    localparam YELLOW_TIME = 8'd5;
    localparam GREEN_TIME  = 8'd60;
    localparam GREEN_SHORT = 8'd10;

    typedef enum reg [1:0] {
        S_RED    = 2'd0,
        S_GREEN  = 2'd1,
        S_YELLOW = 2'd2
    } state_t;

    reg [1:0] state, next_state;
    reg [7:0] cnt, next_cnt;

    // Next state and counter logic (combinational)
    always @(*) begin
        next_state = state;
        next_cnt = cnt;

        case(state)
            S_RED: begin
                if (cnt == 0) begin
                    next_state = S_GREEN;
                    next_cnt = GREEN_TIME;
                end else begin
                    next_cnt = cnt - 1;
                end
            end

            S_GREEN: begin
                if (cnt == 0) begin
                    next_state = S_YELLOW;
                    next_cnt = YELLOW_TIME;
                end else if (pass_request && (cnt > GREEN_SHORT)) begin
                    next_cnt = GREEN_SHORT;
                end else begin
                    next_cnt = cnt - 1;
                end
            end

            S_YELLOW: begin
                if (cnt == 0) begin
                    next_state = S_RED;
                    next_cnt = RED_TIME;
                end else begin
                    next_cnt = cnt - 1;
                end
            end

            default: begin
                next_state = S_RED;
                next_cnt = RED_TIME;
            end
        endcase
    end

    // State and counter registers (synchronous)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= S_RED;
            cnt   <= RED_TIME;
        end else begin
            state <= next_state;
            cnt   <= next_cnt;
        end
    end

    // Outputs assigned from state
    assign red    = (state == S_RED);
    assign green  = (state == S_GREEN);
    assign yellow = (state == S_YELLOW);

    assign clock = cnt;

endmodule