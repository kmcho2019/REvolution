module traffic_light (
    input rst_n,
    input clk,
    input pass_request,
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
    reg [1:0] state;

    reg p_red, p_yellow, p_green; // previous values of light signals

    // State transition and output logic
    always @(*) begin
        // Default next light outputs
        p_red = 1'b0;
        p_yellow = 1'b0;
        p_green = 1'b0;

        case(state)
            idle: begin
                p_red = 1'b0;
                p_yellow = 1'b0;
                p_green = 1'b0;
            end

            s1_red: begin
                p_red = 1'b1;
                p_yellow = 1'b0;
                p_green = 1'b0;
            end

            s2_yellow: begin
                p_red = 1'b0;
                p_yellow = 1'b1;
                p_green = 1'b0;
            end

            s3_green: begin
                p_red = 1'b0;
                p_yellow = 1'b0;
                p_green = 1'b1;
            end

            default: begin
                p_red = 1'b0;
                p_yellow = 1'b0;
                p_green = 1'b0;
            end
        endcase
    end

    // State transition logic based on cnt
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            state <= idle;
        end else begin
            case(state)
                idle: state <= s1_red;

                s1_red: begin
                    if(cnt == 0)
                        state <= s3_green;
                    else
                        state <= s1_red;
                end

                s2_yellow: begin
                    if(cnt == 0)
                        state <= s1_red;
                    else
                        state <= s2_yellow;
                end

                s3_green: begin
                    if(cnt == 0)
                        state <= s2_yellow;
                    else
                        state <= s3_green;
                end

                default: state <= idle;
            endcase
        end
    end

    // Counter update logic
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            cnt <= 8'd10; // Initial red time
        end else begin
            // Detect state transitions by comparing previous and current signals
            // Handle pass_request during green

            // If green active now and pass_request pressed and cnt > 10, shorten cnt to 10
            if(p_green && green && pass_request && cnt > 8'd10) begin
                cnt <= 8'd10;
            end 
            // When green light just turned off (green inactive now, but was active before), set cnt=60
            else if(p_green && !green) begin
                cnt <= 8'd60;
            end
            // When yellow light just turned off (yellow inactive now, but was active before), set cnt=5
            else if(p_yellow && !yellow) begin
                cnt <= 8'd5;
            end
            // When red light just turned off (red inactive now, but was active before), set cnt=10
            else if(p_red && !red) begin
                cnt <= 8'd10;
            end
            // Normal counting down if cnt > 0
            else if(cnt > 0) begin
                cnt <= cnt - 1;
            end
        end
    end

    // Update output signals red, yellow, green and clock (count)
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