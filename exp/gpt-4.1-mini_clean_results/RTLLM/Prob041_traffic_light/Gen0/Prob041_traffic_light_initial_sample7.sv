module traffic_light(
    input           rst_n,
    input           clk,
    input           pass_request,
    output  [7:0]   clock,
    output reg      red,
    output reg      yellow,
    output reg      green
);

    // State encoding
    localparam idle      = 2'd0;
    localparam s1_red    = 2'd1;
    localparam s2_yellow = 2'd2;
    localparam s3_green  = 2'd3;

    reg [7:0] cnt;
    reg [1:0] state;
    reg       p_red, p_yellow, p_green;

    // State transition and output logic
    always @(*) begin
        // Default next output signals zero
        p_red = 1'b0;
        p_yellow = 1'b0;
        p_green = 1'b0;

        case(state)
            idle: begin
                // All lights off in idle
                p_red = 1'b0;
                p_yellow = 1'b0;
                p_green = 1'b0;
            end

            s1_red: begin
                p_red = 1'b1;
            end

            s2_yellow: begin
                p_yellow = 1'b1;
            end

            s3_green: begin
                p_green = 1'b1;
            end

            default: begin
                p_red = 1'b0;
                p_yellow = 1'b0;
                p_green = 1'b0;
            end
        endcase
    end

    // State update and transitions, counter management
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            state <= idle;
            cnt <= 8'd10;
        end else begin
            case(state)
                idle: begin
                    // Move immediately to red state and load red time 10
                    state <= s1_red;
                    cnt <= 8'd10;
                end
                s1_red: begin
                    // Countdown red, when counter reaches 0 move to green
                    if(cnt == 0) begin
                        state <= s3_green;
                        cnt <= 8'd60;  // Set green time 60 cycles at start
                    end
                end
                s2_yellow: begin
                    // Countdown yellow, when counter reaches 0 move to red
                    if(cnt == 0) begin
                        state <= s1_red;
                        cnt <= 8'd10;  // Set red time 10 cycles
                    end
                end
                s3_green: begin
                    // Countdown green, when counter reaches 0 move to yellow
                    if(cnt == 0) begin
                        state <= s2_yellow;
                        cnt <= 8'd5;   // Set yellow time 5 cycles
                    end else if(pass_request && (cnt > 8'd10)) begin
                        // Shorten green time to 10 if pass_request and cnt > 10
                        cnt <= 8'd10;
                    end
                end
            endcase

            // Decrement counter unless it was just loaded above or shortened by pass_request
            // If no transitions or shortening happened above, decrement counter normally
            // The else condition below handles countdown decrement
            if(!((state == s1_red && cnt == 0) || (state == s2_yellow && cnt == 0) || (state == s3_green && cnt == 0) || (state == s3_green && pass_request && (cnt > 8'd10)))) begin
                if(cnt > 0)
                    cnt <= cnt - 1;
            end
        end
    end

    // Assign output clock count
    assign clock = cnt;

    // Output registers update on clk and async reset
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            red <= 1'b0;
            yellow <= 1'b0;
            green <= 1'b0;
        end else begin
            red <= p_red;
            yellow <= p_yellow;
            green <= p_green;
        end
    end

endmodule