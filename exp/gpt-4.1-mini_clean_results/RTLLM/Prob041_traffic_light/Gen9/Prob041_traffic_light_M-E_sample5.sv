module traffic_light (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       pass_request,
    output reg  [7:0] clock,
    output reg        red,
    output reg        yellow,
    output reg        green
);

    // State encoding
    localparam [1:0]
        IDLE    = 2'd0,
        RED_S   = 2'd1,
        GREEN_S = 2'd2,
        YELLOW_S= 2'd3;

    // Timer preset values
    localparam [7:0]
        RED_TIME    = 8'd10,
        YELLOW_TIME = 8'd5,
        GREEN_TIME  = 8'd60,
        SHORT_GREEN = 8'd10;

    reg [1:0] state, next_state;

    // Timer counter
    reg [7:0] cnt;

    // Previous outputs to detect light changes
    reg p_red, p_yellow, p_green;

    // State transition logic
    always @(*) begin
        case (state)
            IDLE:    next_state = RED_S;
            RED_S:   next_state = (cnt == 0) ? GREEN_S : RED_S;
            GREEN_S: next_state = (cnt == 0) ? YELLOW_S : GREEN_S;
            YELLOW_S:next_state = (cnt == 0) ? RED_S : YELLOW_S;
            default: next_state = IDLE;
        endcase
    end

    // Timer loading conditions:
    // - Load preset when entering a new state.
    // - During green state, if pass_request is pressed and cnt > SHORT_GREEN, set cnt to SHORT_GREEN.
    // - Otherwise, decrement cnt if > 0.

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state   <= IDLE;
            cnt     <= 8'd0;
            red     <= 1'b0;
            yellow  <= 1'b0;
            green   <= 1'b0;
            p_red   <= 1'b0;
            p_yellow<= 1'b0;
            p_green <= 1'b0;
            clock   <= 8'd0;
        end else begin
            state <= next_state;

            // Update output lights according to next state
            case (next_state)
                RED_S: begin
                    red    <= 1'b1;
                    yellow <= 1'b0;
                    green  <= 1'b0;
                end
                GREEN_S: begin
                    red    <= 1'b0;
                    yellow <= 1'b0;
                    green  <= 1'b1;
                end
                YELLOW_S: begin
                    red    <= 1'b0;
                    yellow <= 1'b1;
                    green  <= 1'b0;
                end
                IDLE: begin
                    red    <= 1'b0;
                    yellow <= 1'b0;
                    green  <= 1'b0;
                end
            endcase

            // Detect entering a new state by comparing current outputs to previous
            if ((red != p_red) || (yellow != p_yellow) || (green != p_green)) begin
                // State just changed, load counter preset
                if (red && !p_red)        cnt <= RED_TIME;
                else if (green && !p_green) cnt <= GREEN_TIME;
                else if (yellow && !p_yellow) cnt <= YELLOW_TIME;
                else                       cnt <= 8'd0;
            end else begin
                // Same state, update cnt
                if (green) begin
                    if (pass_request && (cnt > SHORT_GREEN)) 
                        cnt <= SHORT_GREEN; // shorten green time if possible
                    else if (cnt > 0)
                        cnt <= cnt - 1;
                end else if ((red || yellow) && (cnt > 0)) begin
                    cnt <= cnt - 1;
                end
            end

            // Update previous light outputs for next cycle
            p_red    <= red;
            p_yellow <= yellow;
            p_green  <= green;

            // Update output clock with current cnt value
            clock <= cnt;
        end
    end

endmodule