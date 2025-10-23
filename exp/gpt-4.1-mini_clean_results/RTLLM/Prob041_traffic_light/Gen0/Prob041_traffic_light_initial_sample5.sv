module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output reg [7:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

    // State enumeration
    typedef enum reg [1:0] {
        idle     = 2'd0,
        s1_red   = 2'd1,
        s2_yellow= 2'd2,
        s3_green = 2'd3
    } state_t;
    
    reg [7:0] cnt;
    reg [1:0] state, next_state;

    reg p_red, p_yellow, p_green;

    // State transition and next output logic
    always @(*) begin
        // Defaults
        next_state = state;
        p_red = 0;
        p_yellow = 0;
        p_green = 0;

        case(state)
            idle: begin
                p_red = 0;
                p_yellow = 0;
                p_green = 0;
                // Transition immediately to s1_red
                next_state = s1_red;
            end

            s1_red: begin
                p_red = 1;
                p_yellow = 0;
                p_green = 0;
                // Stay in s1_red until cnt == 0, then move to s3_green
                if (cnt == 0) begin
                    next_state = s3_green;
                end else begin
                    next_state = s1_red;
                end
            end

            s3_green: begin
                p_red = 0;
                p_yellow = 0;
                p_green = 1;
                // Stay in s3_green until cnt == 0, then move to s2_yellow
                if (cnt == 0) begin
                    next_state = s2_yellow;
                end else begin
                    next_state = s3_green;
                end
            end

            s2_yellow: begin
                p_red = 0;
                p_yellow = 1;
                p_green = 0;
                // Stay in s2_yellow until cnt == 0, then move to s1_red
                if (cnt == 0) begin
                    next_state = s1_red;
                end else begin
                    next_state = s2_yellow;
                end
            end

            default: begin
                next_state = idle;
            end
        endcase
    end

    // Counter and state registers logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // On reset: go to idle and set counter to 10
            state <= idle;
            cnt <= 8'd10;
            p_red <= 0;
            p_yellow <= 0;
            p_green <= 0;
        end else begin
            state <= next_state;

            // Detect state changes to load cnt accordingly
            // When entering states, load initial count
            // For green state, consider shortening due to pass_request
            if (state != next_state) begin
                case(next_state)
                    idle: begin
                        cnt <= 8'd10; // Not really used
                    end

                    s1_red: begin
                        cnt <= 8'd10; // Red state duration = 10
                    end

                    s2_yellow: begin
                        cnt <= 8'd5; // Yellow duration = 5
                    end

                    s3_green: begin
                        // Default green time = 60
                        // If pass_request is active and cnt > 10, shorten to 10
                        // But on transition to s3_green, cnt resets to 60 first
                        cnt <= 8'd60;
                    end

                    default: cnt <= 8'd10;
                endcase
            end else begin
                // Remain in same state, decrement cnt, but adjust if pass_request pressed in green
                if (cnt != 0) begin
                    // Handle pass_request shortening only in green state
                    if ((state == s3_green) && pass_request && (cnt > 10)) begin
                        cnt <= 8'd10;
                    end else begin
                        cnt <= cnt - 1'b1;
                    end
                end
            end
        end
    end

    // Output signals assignment on clock
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            red <= 0;
            yellow <= 0;
            green <= 0;
            clock <= 8'd10;
        end else begin
            red <= p_red;
            yellow <= p_yellow;
            green <= p_green;
            clock <= cnt;
        end
    end

endmodule