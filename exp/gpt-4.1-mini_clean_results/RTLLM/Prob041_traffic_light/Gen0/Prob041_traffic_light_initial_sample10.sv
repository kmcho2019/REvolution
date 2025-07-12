module traffic_light (
    input        rst_n,
    input        clk,
    input        pass_request,
    output [7:0] clock,
    output reg   red,
    output reg   yellow,
    output reg   green
);

    // State encoding
    parameter idle      = 2'b00;
    parameter s1_red    = 2'b01;
    parameter s2_yellow = 2'b10;
    parameter s3_green  = 2'b11;

    reg [7:0] cnt;
    reg [1:0] state;
    reg       p_red, p_yellow, p_green;

    // State transition logic
    always @(*) begin
        // default next outputs 0
        p_red    = 1'b0;
        p_yellow = 1'b0;
        p_green  = 1'b0;

        case(state)
            idle: begin
                // all off in idle, next state s1_red
                p_red    = 1'b0;
                p_yellow = 1'b0;
                p_green  = 1'b0;
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

    // State and counter logic
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            state <= idle;
            cnt   <= 8'd10;
        end else begin
            case(state)
                idle: begin
                    // transition immediately to s1_red
                    state <= s1_red;
                    cnt   <= 8'd10;
                end

                s1_red: begin
                    if(cnt == 0) begin
                        state <= s3_green;
                        cnt   <= 8'd60;
                    end else begin
                        cnt <= cnt - 1;
                    end
                end

                s2_yellow: begin
                    if(cnt == 0) begin
                        state <= s1_red;
                        cnt   <= 8'd10;
                    end else begin
                        cnt <= cnt - 1;
                    end
                end

                s3_green: begin
                    // Handle pedestrian pass_request: if remaining green > 10, shorten to 10
                    if(pass_request && cnt > 10)
                        cnt <= 8'd10;
                    else if(cnt == 0) begin
                        state <= s2_yellow;
                        cnt   <= 8'd5;
                    end else begin
                        cnt <= cnt - 1;
                    end
                end

                default: begin
                    state <= idle;
                    cnt <= 8'd10;
                end
            endcase
        end
    end

    // Output register logic
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

    // assign output clock = current count
    assign clock = cnt;

endmodule