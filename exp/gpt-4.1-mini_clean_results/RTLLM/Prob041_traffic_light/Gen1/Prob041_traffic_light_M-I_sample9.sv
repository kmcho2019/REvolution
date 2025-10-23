module traffic_light(
    input  wire        rst_n,
    input  wire        clk,
    input  wire        pass_request,
    output reg  [7:0]  clock,
    output reg         red,
    output reg         yellow,
    output reg         green
);

    // State encoding
    localparam idle      = 2'd0;
    localparam s1_red    = 2'd1;
    localparam s2_yellow = 2'd2;
    localparam s3_green  = 2'd3;

    reg [1:0] state, next_state;
    reg [7:0] cnt;

    // Flag to track if pass_request shortening applied during current green phase
    reg pass_req_handled;

    // Detect entering new state to reload counter
    wire state_changed = (state != next_state);

    // State transition combinational logic and next state generation
    always @(*) begin
        next_state = state;
        case(state)
            idle: begin
                // Immediately transition to s1_red
                next_state = s1_red;
            end

            s1_red: begin
                if (cnt == 0)
                    next_state = s3_green;
                else
                    next_state = s1_red;
            end

            s3_green: begin
                if (cnt == 0)
                    next_state = s2_yellow;
                else
                    next_state = s3_green;
            end

            s2_yellow: begin
                if (cnt == 0)
                    next_state = s1_red;
                else
                    next_state = s2_yellow;
            end

            default: next_state = idle;
        endcase
    end

    // State and counter sequential logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= idle;
            cnt <= 8'd10;
            pass_req_handled <= 1'b0;
        end else begin
            state <= next_state;

            // Load counter when entering a new state
            if (state_changed) begin
                pass_req_handled <= 1'b0; // clear flag on new state
                case(next_state)
                    idle:      cnt <= 8'd10;  // Not used really
                    s1_red:    cnt <= 8'd10;  // Red duration
                    s2_yellow: cnt <= 8'd5;   // Yellow duration
                    s3_green:  cnt <= 8'd60;  // Green duration
                    default:   cnt <= 8'd10;
                endcase
            end else begin
                // Stay in same state, decrement counter if not zero
                if (cnt != 0) begin
                    // Handle pedestrian pass_request only in green state and only once
                    if ((state == s3_green) && pass_request && (cnt > 10) && !pass_req_handled) begin
                        cnt <= 8'd10;
                        pass_req_handled <= 1'b1;  // mark shortening done
                    end else begin
                        cnt <= cnt - 1'b1;
                    end
                end
            end
        end
    end

    // Output logic depends only on state (Moore FSM style)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            red <= 1'b0;
            yellow <= 1'b0;
            green <= 1'b0;
            clock <= 8'd10;
        end else begin
            case(state)
                idle: begin
                    red <= 1'b0;
                    yellow <= 1'b0;
                    green <= 1'b0;
                end

                s1_red: begin
                    red <= 1'b1;
                    yellow <= 1'b0;
                    green <= 1'b0;
                end

                s2_yellow: begin
                    red <= 1'b0;
                    yellow <= 1'b1;
                    green <= 1'b0;
                end

                s3_green: begin
                    red <= 1'b0;
                    yellow <= 1'b0;
                    green <= 1'b1;
                end

                default: begin
                    red <= 1'b0;
                    yellow <= 1'b0;
                    green <= 1'b0;
                end
            endcase
            clock <= cnt;
        end
    end

endmodule