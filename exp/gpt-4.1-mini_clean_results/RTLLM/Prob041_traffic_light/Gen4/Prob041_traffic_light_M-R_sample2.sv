module traffic_light (
    input        rst_n,
    input        clk,
    input        pass_request,
    output [7:0] clock,
    output       red,
    output       yellow,
    output       green
);

    // Parameterized timing constants
    localparam RED_TIME    = 8'd10;
    localparam YELLOW_TIME = 8'd5;
    localparam GREEN_TIME  = 8'd60;

    // State encoding
    typedef enum logic [1:0] {
        S_RED    = 2'd0,
        S_GREEN  = 2'd1,
        S_YELLOW = 2'd2
    } state_t;

    state_t state, next_state;
    reg [7:0] cnt;

    // Next state logic (combinational)
    always @(*) begin
        next_state = state;
        case (state)
            S_RED: begin
                if (cnt == 0)
                    next_state = S_GREEN;
            end
            S_GREEN: begin
                if (cnt == 0)
                    next_state = S_YELLOW;
            end
            S_YELLOW: begin
                if (cnt == 0)
                    next_state = S_RED;
            end
            default: next_state = S_RED;
        endcase
    end

    // State and counter update (sequential)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= S_RED;
            cnt   <= RED_TIME;
        end else begin
            state <= next_state;
            if (cnt == 0) begin
                // Load new counter value based on next state
                case (next_state)
                    S_RED:    cnt <= RED_TIME;
                    S_GREEN:  cnt <= GREEN_TIME;
                    S_YELLOW: cnt <= YELLOW_TIME;
                    default:  cnt <= RED_TIME;
                endcase
            end else if (state == S_GREEN && pass_request && cnt > 10) begin
                // Shorten green time if pass_request and remaining time > 10
                cnt <= 8'd10;
            end else begin
                cnt <= cnt - 1;
            end
        end
    end

    // Outputs are combinational signals derived from state
    assign red    = (state == S_RED);
    assign yellow = (state == S_YELLOW);
    assign green  = (state == S_GREEN);

    assign clock = cnt;

endmodule