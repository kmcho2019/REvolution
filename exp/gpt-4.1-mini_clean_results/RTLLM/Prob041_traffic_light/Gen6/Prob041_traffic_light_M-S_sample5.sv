module traffic_light (
    input        rst_n,
    input        clk,
    input        pass_request,
    output reg [7:0] clock,
    output       red,
    output       yellow,
    output       green
);

    // Timing constants
    localparam RED_TIME    = 8'd10;
    localparam YELLOW_TIME = 8'd5;
    localparam GREEN_TIME  = 8'd60;

    // State encoding
    typedef enum reg [1:0] {
        IDLE    = 2'd0,
        S_RED   = 2'd1,
        S_YELLOW= 2'd2,
        S_GREEN = 2'd3
    } state_t;

    state_t state, next_state;
    reg [7:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            cnt <= 8'd0;
            clock <= 8'd0;
        end else begin
            case (state)
                IDLE: begin
                    // Transition immediately to red state with red time
                    state <= S_RED;
                    cnt <= RED_TIME;
                end
                S_RED: begin
                    if (cnt == 0) begin
                        state <= S_GREEN;
                        cnt <= GREEN_TIME;
                    end else begin
                        cnt <= cnt - 1;
                    end
                end
                S_GREEN: begin
                    // If pass_request and remaining time > 10, shorten to 10
                    if (pass_request && cnt > 10)
                        cnt <= 8'd10;
                    else if (cnt == 0) begin
                        state <= S_YELLOW;
                        cnt <= YELLOW_TIME;
                    end else begin
                        cnt <= cnt - 1;
                    end
                end
                S_YELLOW: begin
                    if (cnt == 0) begin
                        state <= S_RED;
                        cnt <= RED_TIME;
                    end else begin
                        cnt <= cnt - 1;
                    end
                end
                default: begin
                    state <= IDLE;
                    cnt <= 8'd0;
                end
            endcase
            clock <= cnt;
        end
    end

    // Outputs derived from state
    assign red    = (state == S_RED);
    assign yellow = (state == S_YELLOW);
    assign green  = (state == S_GREEN);

endmodule