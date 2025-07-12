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
    localparam [1:0] idle     = 2'd0,
                     s1_red   = 2'd1,
                     s3_green = 2'd2,
                     s2_yellow= 2'd3;

    // Timing parameters
    localparam RED_TIME    = 8'd10;
    localparam YELLOW_TIME = 8'd5;
    localparam GREEN_TIME  = 8'd60;
    localparam GREEN_SHORT = 8'd10;

    reg [1:0] state, next_state;
    reg [7:0] cnt, next_cnt;

    // Sequential block: state and counter update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= idle;
            cnt   <= 8'd0;
            red   <= 1'b0;
            yellow<= 1'b0;
            green <= 1'b0;
            clock <= 8'd0;
        end else begin
            state <= next_state;
            cnt   <= next_cnt;
            // Registered outputs for stable signals
            case (next_state)
                s1_red: begin
                    red    <= 1'b1;
                    yellow <= 1'b0;
                    green  <= 1'b0;
                end
                s2_yellow: begin
                    red    <= 1'b0;
                    yellow <= 1'b1;
                    green  <= 1'b0;
                end
                s3_green: begin
                    red    <= 1'b0;
                    yellow <= 1'b0;
                    green  <= 1'b1;
                end
                default: begin // idle or unknown state
                    red    <= 1'b0;
                    yellow <= 1'b0;
                    green  <= 1'b0;
                end
            endcase
            clock <= cnt;
        end
    end

    // Combinational block: determine next state and counter
    always @(*) begin
        // Default next state and count same as current
        next_state = state;
        next_cnt   = cnt;

        case(state)
            idle: begin
                // On idle, immediately go to red with red time
                next_state = s1_red;
                next_cnt   = RED_TIME;
            end
            s1_red: begin
                if (cnt == 0) begin
                    // Red time done, transition to green with full green time
                    next_state = s3_green;
                    next_cnt   = GREEN_TIME;
                end else begin
                    next_state = s1_red;
                    next_cnt   = cnt - 1;
                end
            end
            s3_green: begin
                // Green state: check pedestrian button for shortening time
                if (cnt == 0) begin
                    // Green done, go to yellow with yellow time
                    next_state = s2_yellow;
                    next_cnt   = YELLOW_TIME;
                end else begin
                    // If pedestrian requests pass and remaining green time > 10, shorten to 10
                    if (pass_request && (cnt > GREEN_SHORT)) begin
                        next_cnt = GREEN_SHORT;
                    end else begin
                        next_cnt = cnt - 1;
                    end
                    next_state = s3_green;
                end
            end
            s2_yellow: begin
                if (cnt == 0) begin
                    // Yellow done, go back to red with red time
                    next_state = s1_red;
                    next_cnt   = RED_TIME;
                end else begin
                    next_state = s2_yellow;
                    next_cnt   = cnt - 1;
                end
            end
            default: begin
                // Safety fallback: go to idle
                next_state = idle;
                next_cnt   = 0;
            end
        endcase
    end

endmodule