module traffic_light(
    input rst_n,
    input clk,
    input pass_request,
    output reg [7:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);
    // State encoding
    localparam [1:0] idle     = 2'd0,
                     s1_red   = 2'd1,
                     s2_yellow= 2'd2,
                     s3_green = 2'd3;

    reg [7:0] cnt;
    reg [1:0] state;
    reg p_red, p_yellow, p_green;

    // State transition and next output logic
    always @(*) begin
        // Default outputs for next state
        p_red = 0;
        p_yellow = 0;
        p_green = 0;

        case(state)
            idle: begin
                // All off in idle
                p_red = 0;
                p_yellow = 0;
                p_green = 0;
            end
            s1_red: begin
                p_red = 1;
                p_yellow = 0;
                p_green = 0;
            end
            s2_yellow: begin
                p_red = 0;
                p_yellow = 1;
                p_green = 0;
            end
            s3_green: begin
                p_red = 0;
                p_yellow = 0;
                p_green = 1;
            end
            default: begin
                p_red = 0;
                p_yellow = 0;
                p_green = 0;
            end
        endcase
    end

    // State and counter management
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= idle;
            cnt <= 10; // per spec initialization
        end else begin
            case(state)
                idle: begin
                    // Immediate transition to s1_red
                    state <= s1_red;
                    cnt <= 10; // red duration
                end
                s1_red: begin
                    if (cnt == 0) begin
                        state <= s3_green;
                        cnt <= 60; // green duration
                    end else begin
                        cnt <= cnt - 1;
                    end
                end
                s3_green: begin
                    if (pass_request && (cnt > 10)) begin
                        // shorten green time to 10 if remaining > 10
                        cnt <= 10;
                    end else if (cnt == 0) begin
                        state <= s2_yellow;
                        cnt <= 5; // yellow duration
                    end else begin
                        cnt <= cnt - 1;
                    end
                end
                s2_yellow: begin
                    if (cnt == 0) begin
                        state <= s1_red;
                        cnt <= 10; // red duration
                    end else begin
                        cnt <= cnt - 1;
                    end
                end
                default: begin
                    state <= idle;
                    cnt <= 10;
                end
            endcase
        end
    end

    // Output registers update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            red <= 0;
            yellow <= 0;
            green <= 0;
        end else begin
            red <= p_red;
            yellow <= p_yellow;
            green <= p_green;
        end
    end

    // Assign cnt to output clock
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            clock <= 0;
        end else begin
            clock <= cnt;
        end
    end

endmodule