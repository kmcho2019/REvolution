module traffic_light (
    input wire rst_n,
    input wire clk,
    input wire pass_request,
    output reg [7:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

    // State encoding
    localparam idle     = 2'd0;
    localparam s1_red   = 2'd1;
    localparam s2_yellow= 2'd2;
    localparam s3_green = 2'd3;

    reg [7:0] cnt;
    reg [1:0] state, next_state;

    reg p_red, p_yellow, p_green; // previous output signals for edge detection

    // State transition logic and output next values
    always @(*) begin
        // defaults
        next_state = state;
        p_red = 1'b0;
        p_yellow = 1'b0;
        p_green = 1'b0;

        case(state)
            idle: begin
                p_red = 1'b0;
                p_yellow = 1'b0;
                p_green = 1'b0;
                next_state = s1_red; // immediately go to s1_red
            end
            s1_red: begin
                p_red = 1'b1;
                if(cnt == 0) begin
                    next_state = s3_green;
                end else begin
                    next_state = s1_red;
                end
            end
            s2_yellow: begin
                p_yellow = 1'b1;
                if(cnt == 0) begin
                    next_state = s1_red;
                end else begin
                    next_state = s2_yellow;
                end
            end
            s3_green: begin
                p_green = 1'b1;
                if(cnt == 0) begin
                    next_state = s2_yellow;
                end else begin
                    next_state = s3_green;
                end
            end
            default: begin
                p_red = 1'b0;
                p_yellow = 1'b0;
                p_green = 1'b0;
                next_state = idle;
            end
        endcase
    end

    // Counter logic and state update
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            state <= idle;
            cnt <= 8'd10; // start with red time preset (10)
        end else begin
            state <= next_state;

            // Detect state changes by comparing current and next state
            // Handle counter preset when state changes
            if(state != next_state) begin
                case(next_state)
                    s1_red: cnt <= 8'd10;   // red 10 cycles
                    s2_yellow: cnt <= 8'd5; // yellow 5 cycles
                    s3_green: cnt <= 8'd60; // green normal 60 cycles
                    default: cnt <= 8'd10;
                endcase
            end else begin
                // In same state, handle pass_request shortening green time
                if(next_state == s3_green) begin
                    // If pass_request and cnt > 10, shorten to 10
                    if(pass_request && cnt > 8'd10) begin
                        cnt <= 8'd10;
                    end else if(cnt > 0) begin
                        cnt <= cnt - 1;
                    end
                end else begin
                    // For red and yellow states just count down if cnt>0
                    if(cnt > 0)
                        cnt <= cnt - 1;
                end
            end
        end
    end

    // Update output signals on clock
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            red <= 1'b0;
            yellow <= 1'b0;
            green <= 1'b0;
            clock <= 8'd0;
        end else begin
            red <= p_red;
            yellow <= p_yellow;
            green <= p_green;
            clock <= cnt;
        end
    end

endmodule