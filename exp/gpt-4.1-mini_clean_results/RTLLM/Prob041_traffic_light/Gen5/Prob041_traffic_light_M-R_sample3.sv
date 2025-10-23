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

    reg [1:0] state, next_state;
    reg [7:0] cnt, next_cnt;
    reg pass_request_reg;

    wire cnt_expired = (cnt == 8'd0);

    // Synchronize pass_request to clk domain to avoid metastability and glitches
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            pass_request_reg <= 1'b0;
        else
            pass_request_reg <= pass_request;
    end

    // Next state logic combinational
    always @(*) begin
        // Default assignments
        next_state = state;
        next_cnt = cnt;

        case(state)
            idle: begin
                // Immediately transition to red with 10 cycles
                next_state = s1_red;
                next_cnt = 8'd10;
            end

            s1_red: begin
                if(cnt_expired) begin
                    next_state = s3_green;
                    next_cnt = 8'd60;
                end
            end

            s2_yellow: begin
                if(cnt_expired) begin
                    next_state = s1_red;
                    next_cnt = 8'd10;
                end
            end

            s3_green: begin
                if(cnt_expired) begin
                    next_state = s2_yellow;
                    next_cnt = 8'd5;
                end else if(pass_request_reg && (cnt > 8'd10)) begin
                    // Shorten green time to 10 if possible
                    next_cnt = 8'd10;
                end
            end

            default: begin
                next_state = idle;
                next_cnt = 8'd10;
            end
        endcase
    end

    // State and counter update synchronous block
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            state <= idle;
            cnt <= 8'd10;
        end else begin
            state <= next_state;
            cnt <= next_cnt;
        end
    end

    // Counter decrement enable: decrement only if not expired and not just reloaded or shortened
    wire dec_enable;
    assign dec_enable = (cnt != 0) && 
                        !((state == s1_red && next_state == s3_green) || 
                          (state == s2_yellow && next_state == s1_red) ||
                          (state == s3_green && next_state == s2_yellow) ||
                          (state == s3_green && pass_request_reg && cnt > 8'd10 && next_cnt == 8'd10));

    // Counter decrement block: decrement cnt by 1 if enabled (this is a small trick: cnt updated synchronously above,
    // here decrement only if enabled to avoid counting down during reload)
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            // Already reset cnt above, no action
        end else if(dec_enable) begin
            cnt <= cnt - 1;
        end
    end

    // Output logic: assign outputs based on current state
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            red <= 1'b0;
            yellow <= 1'b0;
            green <= 1'b0;
        end else begin
            case(state)
                s1_red: begin
                    red <= 1'b1;
                    yellow <= 1'b0;
                    green <= 1'b0;
                end
                s2_yellow: begin
                    red <= 1'b0;
                    yellow <= 1'b1;
                    green <= 1'b0;
                end
                s3_green: begin
                    red <= 1'b0;
                    yellow <= 1'b0;
                    green <= 1'b1;
                end
                default: begin
                    red <= 1'b0;
                    yellow <= 1'b0;
                    green <= 1'b0;
                end
            endcase
        end
    end

    assign clock = cnt;

endmodule