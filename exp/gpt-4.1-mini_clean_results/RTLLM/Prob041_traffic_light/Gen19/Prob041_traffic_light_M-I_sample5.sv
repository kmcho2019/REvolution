module traffic_light (
    input         rst_n,
    input         clk,
    input         pass_request,
    output reg [7:0] clock,
    output reg    red,
    output reg    yellow,
    output reg    green
);

    // Timing parameters
    localparam [7:0]
        RED_TIME    = 8'd10,
        YELLOW_TIME = 8'd5,
        GREEN_TIME  = 8'd60,
        GREEN_SHORT = 8'd10;

    // State encoding
    localparam [1:0]
        S_RED    = 2'd0,
        S_GREEN  = 2'd1,
        S_YELLOW = 2'd2;

    reg [1:0] state, next_state;
    reg [7:0] cnt, next_cnt;

    // State register with synchronous active-low reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= S_RED;
            cnt   <= RED_TIME;
        end else begin
            state <= next_state;
            cnt   <= next_cnt;
        end
    end

    // Next state and counter logic
    always @(*) begin
        next_state = state;
        next_cnt = cnt;

        case (state)
            S_RED: begin
                if (cnt == 0) begin
                    next_state = S_GREEN;
                    next_cnt = GREEN_TIME;
                end else if (cnt > 0) begin
                    next_cnt = cnt - 1;
                end
            end

            S_GREEN: begin
                // If pass_request asserted and cnt > 10, shorten cnt to 10
                if ((pass_request) && (cnt > GREEN_SHORT)) begin
                    next_cnt = GREEN_SHORT;
                end else if (cnt == 0) begin
                    next_state = S_YELLOW;
                    next_cnt = YELLOW_TIME;
                end else if (cnt > 0) begin
                    next_cnt = cnt - 1;
                end
            end

            S_YELLOW: begin
                if (cnt == 0) begin
                    next_state = S_RED;
                    next_cnt = RED_TIME;
                end else if (cnt > 0) begin
                    next_cnt = cnt - 1;
                end
            end

            default: begin
                next_state = S_RED;
                next_cnt = RED_TIME;
            end
        endcase
    end

    // Output logic: registered outputs for glitch reduction and lower toggle
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            red    <= 1'b0;
            yellow <= 1'b0;
            green  <= 1'b0;
            clock  <= 8'd0;
        end else begin
            clock <= cnt;
            red    <= (state == S_RED);
            yellow <= (state == S_YELLOW);
            green  <= (state == S_GREEN);
        end
    end

endmodule