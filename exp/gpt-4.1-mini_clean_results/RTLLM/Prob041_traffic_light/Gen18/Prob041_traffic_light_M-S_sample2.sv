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
    localparam RED_TIME    = 8'd10;
    localparam YELLOW_TIME = 8'd5;
    localparam GREEN_TIME  = 8'd60;
    localparam GREEN_SHORT = 8'd10;

    // State encoding
    localparam IDLE   = 2'd0;
    localparam S1_RED = 2'd1;
    localparam S2_YELLOW = 2'd2;
    localparam S3_GREEN  = 2'd3;

    reg [1:0] state, next_state;
    reg [7:0] cnt, next_cnt;

    // State and counter update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            cnt <= 8'd10;
        end else begin
            state <= next_state;
            cnt <= next_cnt;
        end
    end

    // Next state and counter combinational logic
    always @(*) begin
        next_state = state;
        next_cnt = cnt;

        case(state)
            IDLE: begin
                // Immediate transition to red state
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

            S2_YELLOW: begin
                if (cnt == 0) begin
                    next_state = S1_RED;
                    next_cnt = RED_TIME;
                end else begin
                    next_cnt = cnt - 1;
                end
            end

            S3_GREEN: begin
                if (cnt == 0) begin
                    next_state = S2_YELLOW;
                    next_cnt = YELLOW_TIME;
                end else begin
                    if (pass_request && (cnt > GREEN_SHORT))
                        next_cnt = GREEN_SHORT;
                    else
                        next_cnt = cnt - 1;
                end
            end

            default: begin
                next_state = IDLE;
                next_cnt = RED_TIME;
            end
        endcase
    end

    // Outputs derived from state
    assign red    = (state == S1_RED);
    assign yellow = (state == S2_YELLOW);
    assign green  = (state == S3_GREEN);

    // Output the current counter value
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clock <= 8'd0;
        else
            clock <= cnt;
    end

endmodule