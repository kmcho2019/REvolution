module traffic_light (
    input        rst_n,
    input        clk,
    input        pass_request,
    output reg [7:0] clock,
    output       red,
    output       yellow,
    output       green
);

    // State encoding
    localparam idle     = 2'd0;
    localparam s1_red   = 2'd1;
    localparam s2_yellow= 2'd2;
    localparam s3_green = 2'd3;

    reg [1:0] state, next_state;
    reg [7:0] cnt, next_cnt;

    // State and counter update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= idle;
            cnt <= 8'd10;  // default count for idle
        end else begin
            state <= next_state;
            cnt <= next_cnt;
        end
    end

    // Next state and next counter logic
    always @(*) begin
        next_state = state;
        next_cnt = cnt;

        case (state)
            idle: begin
                // Immediately go to red state with cnt=10
                next_state = s1_red;
                next_cnt = 8'd10;
            end

            s1_red: begin
                if (cnt == 0) begin
                    next_state = s3_green;
                    next_cnt = 8'd60;
                end else begin
                    next_cnt = cnt - 1;
                end
            end

            s3_green: begin
                // Pedestrian request shortens green to 10 if cnt>10
                if (pass_request && cnt > 8'd10)
                    next_cnt = 8'd10;
                else if (cnt == 0) begin
                    next_state = s2_yellow;
                    next_cnt = 8'd5;
                end else begin
                    next_cnt = cnt - 1;
                end
            end

            s2_yellow: begin
                if (cnt == 0) begin
                    next_state = s1_red;
                    next_cnt = 8'd10;
                end else begin
                    next_cnt = cnt - 1;
                end
            end

            default: begin
                next_state = idle;
                next_cnt = 8'd10;
            end
        endcase
    end

    // Outputs combinationally from state
    assign red    = (state == s1_red);
    assign yellow = (state == s2_yellow);
    assign green  = (state == s3_green);

    // clock output directly from cnt
    always @(*) begin
        clock = cnt;
    end

endmodule