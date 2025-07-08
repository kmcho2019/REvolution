module traffic_light (
    input wire rst_n,
    input wire clk,
    input wire pass_request,
    output wire [7:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

    // State encoding
    localparam [1:0]
        idle     = 2'd0,
        s1_red   = 2'd1,
        s2_yellow= 2'd2,
        s3_green = 2'd3;

    reg [7:0] cnt;
    reg [1:0] state;
    reg p_red, p_yellow, p_green;

    // State transition logic and output next signals
    always @(*) begin
        // Default next signals off
        p_red = 1'b0;
        p_yellow = 1'b0;
        p_green = 1'b0;
        case(state)
            idle: begin
                // all off, transition to red immediately
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

    // State machine sequential logic
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            state <= idle;
        end else begin
            case(state)
                idle: begin
                    // immediately go to red state
                    state <= s1_red;
                end
                s1_red: begin
                    if(cnt == 8'd0) begin
                        state <= s3_green;
                    end else begin
                        state <= s1_red;
                    end
                end
                s2_yellow: begin
                    if(cnt == 8'd0) begin
                        state <= s1_red;
                    end else begin
                        state <= s2_yellow;
                    end
                end
                s3_green: begin
                    if(cnt == 8'd0) begin
                        state <= s2_yellow;
                    end else begin
                        state <= s3_green;
                    end
                end
                default: state <= idle;
            endcase
        end
    end

    // Counter logic with pedestrian button handling
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            cnt <= 8'd10; // initial count for red on reset
        end else begin
            // Capture the previous outputs to detect transitions
            // This is for detecting state changes and adjusting count accordingly
            // We'll compare current p_* with previous red/yellow/green signals

            // Pedestrian request shortening green time
            if(pass_request && p_green) begin
                // if remaining green time > 10, shorten to 10
                if(cnt > 8'd10) begin
                    cnt <= 8'd10;
                end else begin
                    // remain unchanged if cnt <= 10
                    cnt <= cnt - 1;
                end
            end else if(!p_green && green) begin
                // green just turned off, set count for green state duration
                cnt <= 8'd60;
            end else if(!p_yellow && yellow) begin
                // yellow just turned off, set count for yellow duration
                cnt <= 8'd5;
            end else if(!p_red && red) begin
                // red just turned off, set count for red duration
                cnt <= 8'd10;
            end else if(cnt != 8'd0) begin
                // normal counting down
                cnt <= cnt - 1;
            end else begin
                // remain zero if count finished
                cnt <= cnt;
            end
        end
    end

    // Output registers updated on clock or reset
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            red    <= 1'b0;
            yellow <= 1'b0;
            green  <= 1'b0;
        end else begin
            red    <= p_red;
            yellow <= p_yellow;
            green  <= p_green;
        end
    end

    assign clock = cnt;

endmodule