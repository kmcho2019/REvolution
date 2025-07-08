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
    localparam idle      = 2'd0;
    localparam s1_red    = 2'd1;
    localparam s2_yellow = 2'd2;
    localparam s3_green  = 2'd3;

    reg [7:0] cnt;
    reg [1:0] state;
    reg p_red, p_yellow, p_green;

    // State transition and output logic
    always @(*) begin
        // Default next state is current state
        // Default outputs are zero
        case(state)
            idle: begin
                // immediately go to s1_red
                p_red = 0;
                p_yellow = 0;
                p_green = 0;
            end

            s1_red: begin
                // red light on
                p_red = 1;
                p_yellow = 0;
                p_green = 0;
            end

            s2_yellow: begin
                // yellow light on
                p_red = 0;
                p_yellow = 1;
                p_green = 0;
            end

            s3_green: begin
                // green light on
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

    // FSM next state and counter reload logic
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            state <= idle;
            cnt <= 8'd10; // arbitrary reset value
        end else begin
            case(state)
                idle: begin
                    state <= s1_red;
                    cnt <= 8'd10; // red duration 10 clocks
                end

                s1_red: begin
                    if(cnt == 0) begin
                        state <= s3_green;
                        cnt <= 8'd60; // green duration 60 clocks
                    end
                end

                s2_yellow: begin
                    if(cnt == 0) begin
                        state <= s1_red;
                        cnt <= 8'd10; // red duration 10 clocks
                    end
                end

                s3_green: begin
                    if(cnt == 0) begin
                        state <= s2_yellow;
                        cnt <= 8'd5;  // yellow duration 5 clocks
                    end else if(pass_request && cnt > 8'd10) begin
                        // shorten remaining green time to 10 clocks
                        cnt <= 8'd10;
                    end
                end

                default: begin
                    state <= idle;
                    cnt <= 8'd10;
                end
            endcase
            if(state != s3_green || (pass_request && cnt > 8'd10)) begin
                // In states other than green or when shortening green, cnt is decremented
                if(cnt != 0)
                    cnt <= cnt - 1'b1;
            end else if(state == s3_green && (!pass_request || cnt <= 8'd10)) begin
                // In green state with no shortening request or already short time
                if(cnt != 0)
                    cnt <= cnt - 1'b1;
            end
        end
    end

    // Outputs update
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
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