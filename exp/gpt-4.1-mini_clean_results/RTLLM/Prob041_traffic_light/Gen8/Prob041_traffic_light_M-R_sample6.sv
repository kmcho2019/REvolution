module traffic_light (
    input        rst_n,
    input        clk,
    input        pass_request,
    output reg [7:0] clock,
    output reg    red,
    output reg    yellow,
    output reg    green
);

    // State encoding
    localparam [1:0]
        idle      = 2'd0,
        s1_red    = 2'd1,
        s2_yellow = 2'd2,
        s3_green  = 2'd3;

    // Timing constants
    localparam [7:0]
        RED_TIME    = 8'd10,
        YELLOW_TIME = 8'd5,
        GREEN_TIME  = 8'd60,
        GREEN_SHORT = 8'd10;

    reg [7:0] cnt;
    reg [1:0] state, next_state;

    // State transition logic (Moore FSM)
    always @(*) begin
        case (state)
            idle:      next_state = s1_red;
            s1_red:    next_state = (cnt == 0) ? s3_green  : s1_red;
            s2_yellow: next_state = (cnt == 0) ? s1_red    : s2_yellow;
            s3_green:  next_state = (cnt == 0) ? s2_yellow : s3_green;
            default:   next_state = idle;
        endcase
    end

    // Counter update and load logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= idle;
            cnt   <= 8'd10;  // initial red time after reset
        end else begin
            state <= next_state;

            if (state != next_state) begin
                // Load counter at state transition
                case (next_state)
                    s1_red:    cnt <= RED_TIME;
                    s2_yellow: cnt <= YELLOW_TIME;
                    s3_green:  cnt <= GREEN_TIME;
                    default:   cnt <= 8'd10;
                endcase
            end else if (state == s3_green) begin
                // Pedestrian button may shorten green time if remaining > GREEN_SHORT
                if (pass_request && (cnt > GREEN_SHORT))
                    cnt <= GREEN_SHORT;
                else if (cnt != 0)
                    cnt <= cnt - 1;
            end else if (cnt != 0) begin
                cnt <= cnt - 1;
            end
            // else cnt == 0: stay at zero until state change on next cycle
        end
    end

    // Registered outputs, updated at clock edge
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            red    <= 1'b0;
            yellow <= 1'b0;
            green  <= 1'b0;
            clock  <= 8'd0;
        end else begin
            case (state)
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
                default: begin
                    red    <= 1'b0;
                    yellow <= 1'b0;
                    green  <= 1'b0;
                end
            endcase
            clock <= cnt;
        end
    end

endmodule