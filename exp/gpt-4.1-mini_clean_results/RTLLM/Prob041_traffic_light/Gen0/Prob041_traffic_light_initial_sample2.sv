module traffic_light(
    input  wire       rst_n,
    input  wire       clk,
    input  wire       pass_request,
    output reg  [7:0] clock,
    output reg        red,
    output reg        yellow,
    output reg        green
);

    // State encoding
    localparam idle     = 2'd0;
    localparam s1_red   = 2'd1;
    localparam s2_yellow= 2'd2;
    localparam s3_green = 2'd3;

    reg [7:0] cnt;
    reg [1:0] state;
    reg p_red, p_yellow, p_green;

    // State transition and light output signals (next state logic)
    always @(*) begin
        // default next-state and light signals
        p_red    = 1'b0;
        p_yellow = 1'b0;
        p_green  = 1'b0;

        case(state)
            idle: begin
                // all off, transition immediately to s1_red
                p_red = 1'b0; p_yellow = 1'b0; p_green = 1'b0;
            end
            s1_red: begin
                p_red = 1'b1; p_yellow = 1'b0; p_green = 1'b0;
            end
            s2_yellow: begin
                p_red = 1'b0; p_yellow = 1'b1; p_green = 1'b0;
            end
            s3_green: begin
                p_red = 1'b0; p_yellow = 1'b0; p_green = 1'b1;
            end
            default: begin
                p_red = 1'b0; p_yellow = 1'b0; p_green = 1'b0;
            end
        endcase
    end

    // State machine sequential logic and transitions
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= idle;
            cnt <= 8'd10;
        end else begin
            case(state)
                idle: begin
                    // Transition immediately to s1_red with counter = 10
                    state <= s1_red;
                    cnt <= 8'd10;
                end
                s1_red: begin
                    if (cnt == 0) begin
                        state <= s3_green;
                        cnt <= 8'd60;
                    end else begin
                        // remain in s1_red
                        state <= s1_red;
                    end
                end
                s2_yellow: begin
                    if (cnt == 0) begin
                        state <= s1_red;
                        cnt <= 8'd10;
                    end else begin
                        state <= s2_yellow;
                    end
                end
                s3_green: begin
                    if (cnt == 0) begin
                        state <= s2_yellow;
                        cnt <= 8'd5;
                    end else begin
                        state <= s3_green;
                    end
                end
                default: begin
                    state <= idle;
                    cnt <= 8'd10;
                end
            endcase
        end
    end

    // Counter control logic with pedestrian pass_request logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 8'd10;
        end else begin
            case(state)
                s1_red: begin
                    if (cnt != 0)
                        cnt <= cnt - 1;
                end
                s2_yellow: begin
                    if (cnt != 0)
                        cnt <= cnt - 1;
                end
                s3_green: begin
                    // If pedestrian button pressed and remaining time > 10, shorten to 10
                    if (pass_request && (cnt > 10))
                        cnt <= 8'd10;
                    else if (cnt != 0)
                        cnt <= cnt - 1;
                end
                default: begin
                    // no counting
                    cnt <= cnt;
                end
            endcase
        end
    end

    // Output the current count value
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            clock <= 8'd0;
        end else begin
            clock <= cnt;
        end
    end

    // Register outputs red, yellow, green on clk or reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            red    <= 1'b0;
            yellow <= 1'b0;
            green  <= 1'b0;
        end else begin
            red    <= p_red;
            yellow <= p_yellow;
            green  <= p_green;
        end
    end

endmodule