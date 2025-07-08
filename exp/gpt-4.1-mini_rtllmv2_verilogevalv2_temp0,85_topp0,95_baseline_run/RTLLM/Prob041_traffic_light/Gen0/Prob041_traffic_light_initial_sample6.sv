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
    localparam idle     = 2'b00;
    localparam s1_red   = 2'b01;
    localparam s2_yellow= 2'b10;
    localparam s3_green = 2'b11;

    reg [7:0] cnt;
    reg [1:0] state;
    reg p_red, p_yellow, p_green;

    // State transition and output next state logic
    always @(*) begin
        // Defaults: clear outputs
        p_red = 1'b0;
        p_yellow = 1'b0;
        p_green = 1'b0;

        case(state)
            idle: begin
                // All off in idle
                p_red = 1'b0;
                p_yellow = 1'b0;
                p_green = 1'b0;
            end
            s1_red: begin
                p_red = 1'b1;
                if(cnt == 8'd0)
                    ; // wait for counter to reload and decrement to 0 before transition
            end
            s2_yellow: begin
                p_yellow = 1'b1;
                if(cnt == 8'd0)
                    ; // wait for counter to reload and decrement to 0 before transition
            end
            s3_green: begin
                p_green = 1'b1;
                if(cnt == 8'd0)
                    ; // wait for counter to reload and decrement to 0 before transition
            end
            default: begin
                p_red = 1'b0;
                p_yellow = 1'b0;
                p_green = 1'b0;
            end
        endcase
    end

    // State transition logic with timer control
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            state <= idle;
            cnt <= 8'd10;
        end
        else begin
            case(state)
                idle: begin
                    // Immediately transition to s1_red with red counter 10
                    state <= s1_red;
                    cnt <= 8'd10;
                end
                s1_red: begin
                    if(cnt == 8'd0) begin
                        state <= s3_green;
                        cnt <= 8'd60; // green duration
                    end
                    else begin
                        cnt <= cnt - 1'b1;
                    end
                end
                s2_yellow: begin
                    if(cnt == 8'd0) begin
                        state <= s1_red;
                        cnt <= 8'd10; // red duration
                    end
                    else begin
                        cnt <= cnt - 1'b1;
                    end
                end
                s3_green: begin
                    if(pass_request && (cnt > 8'd10)) begin
                        cnt <= 8'd10; // shorten green duration on pedestrian press
                    end
                    else if(cnt == 8'd0) begin
                        state <= s2_yellow;
                        cnt <= 8'd5; // yellow duration
                    end
                    else begin
                        cnt <= cnt - 1'b1;
                    end
                end
                default: begin
                    state <= idle;
                    cnt <= 8'd10;
                end
            endcase
        end
    end

    // Output and previous signals update
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            red <= 1'b0;
            yellow <= 1'b0;
            green <= 1'b0;
        end
        else begin
            red <= p_red;
            yellow <= p_yellow;
            green <= p_green;
        end
    end

    // Assign counter to output clock
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            clock <= 8'd10;
        else
            clock <= cnt;
    end

endmodule