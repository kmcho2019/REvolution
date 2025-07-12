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
    parameter idle      = 2'd0;
    parameter s1_red    = 2'd1;
    parameter s2_yellow = 2'd2;
    parameter s3_green  = 2'd3;

    reg [7:0] cnt;
    reg [1:0] state;
    reg p_red, p_yellow, p_green;

    // Next state and outputs logic
    always @(*) begin
        // Default assignments
        p_red = 1'b0;
        p_yellow = 1'b0;
        p_green = 1'b0;

        case(state)
            idle: begin
                // All signals off, will move to red immediately
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

    // State transition logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= idle;
        end else begin
            case(state)
                idle: begin
                    // Immediately go to red state on reset release
                    state <= s1_red;
                end
                s1_red: begin
                    // Stay until count reaches 3, then green
                    if(cnt == 8'd0)
                        state <= s3_green;
                    else
                        state <= s1_red;
                end
                s2_yellow: begin
                    // Stay until count reaches 0, then red
                    if(cnt == 8'd0)
                        state <= s1_red;
                    else
                        state <= s2_yellow;
                end
                s3_green: begin
                    // Stay until count reaches 0, then yellow
                    if(cnt == 8'd0)
                        state <= s2_yellow;
                    else
                        state <= s3_green;
                end
                default: state <= idle;
            endcase
        end
    end

    // Counter logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 8'd10;
        end else begin
            case(state)
                idle: begin
                    cnt <= 8'd10;
                end
                s1_red: begin
                    if(cnt == 8'd0)
                        cnt <= 8'd60; // After red goes to green for 60
                    else
                        cnt <= cnt - 8'd1;
                end
                s2_yellow: begin
                    if(cnt == 8'd0)
                        cnt <= 8'd10; // After yellow goes to red for 10
                    else
                        cnt <= cnt - 8'd1;
                end
                s3_green: begin
                    if(pass_request && cnt > 8'd10) begin
                        cnt <= 8'd10;
                    end else if(cnt > 0) begin
                        cnt <= cnt - 8'd1;
                    end else begin
                        cnt <= 8'd5; // After green goes to yellow for 5
                    end
                end
                default: cnt <= 8'd10;
            endcase
        end
    end

    // Assign internal counter to output clock
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            clock <= 8'd0;
        else
            clock <= cnt;
    end

    // Output registers updated synchronously with next values
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

endmodule