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
    parameter idle     = 2'b00;
    parameter s1_red   = 2'b01;
    parameter s2_yellow= 2'b10;
    parameter s3_green = 2'b11;

    reg [7:0] cnt;
    reg [1:0] state;
    reg p_red, p_yellow, p_green;

    // State transition and output logic
    always @(*) begin
        case(state)
            idle: begin
                // Turn off all lights initially
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

    // Counter and state update logic
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            cnt <= 10;
            state <= idle;
        end else begin
            case(state)
                idle: begin
                    // Transition immediately to s1_red with cnt=10
                    state <= s1_red;
                    cnt <= 10;
                end
                s1_red: begin
                    if(cnt == 0) begin
                        state <= s3_green;
                        cnt <= 60;
                    end else begin
                        cnt <= cnt - 1;
                    end
                end
                s2_yellow: begin
                    if(cnt == 0) begin
                        state <= s1_red;
                        cnt <= 10;
                    end else begin
                        cnt <= cnt - 1;
                    end
                end
                s3_green: begin
                    // When pass_request occurs and remaining green time > 10, shorten to 10
                    if(pass_request && cnt > 10) begin
                        cnt <= 10;
                    end else if(cnt == 0) begin
                        state <= s2_yellow;
                        cnt <= 5;
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

    // Update registered outputs on clock or reset
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            red <= 0;
            yellow <= 0;
            green <= 0;
        end else begin
            red <= p_red;
            yellow <= p_yellow;
            green <= p_green;
        end
    end

    // Assign output clock to current count
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            clock <= 10;
        end else begin
            clock <= cnt;
        end
    end

endmodule