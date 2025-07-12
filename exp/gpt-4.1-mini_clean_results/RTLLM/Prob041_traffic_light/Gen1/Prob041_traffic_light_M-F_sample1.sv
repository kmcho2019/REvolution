module traffic_light (
    input         rst_n,
    input         clk,
    input         pass_request,
    output reg [7:0] clock,
    output reg    red,
    output reg    yellow,
    output reg    green
);

    // State encoding
    parameter idle      = 2'd0;
    parameter s1_red    = 2'd1;
    parameter s2_yellow = 2'd2;
    parameter s3_green  = 2'd3;

    reg [1:0] state, next_state;
    reg [7:0] cnt, next_cnt;
    reg pass_req_latched; // To latch pass_request once per green phase

    // State and counter update synchronous block
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= idle;
            cnt <= 8'd0;
            pass_req_latched <= 1'b0;
        end else begin
            state <= next_state;
            cnt <= next_cnt;

            // Reset pass_req_latched at the start of green phase
            if (next_state == s3_green && state != s3_green)
                pass_req_latched <= 1'b0;
            else if (pass_request && (state == s3_green) && !pass_req_latched && (cnt > 8'd10))
                pass_req_latched <= 1'b1;
        end
    end

    // Next state and counter combinational logic
    always @(*) begin
        // Defaults to hold state and count down if >0
        next_state = state;
        next_cnt = (cnt > 0) ? cnt - 1 : 0;

        case(state)
            idle: begin
                // Immediately transition to red with cnt=10
                next_state = s1_red;
                next_cnt = 8'd10;
            end

            s1_red: begin
                // Count down red 10 clocks
                if (cnt == 0) begin
                    next_state = s3_green;
                    next_cnt = 8'd60;
                end
            end

            s3_green: begin
                // Green phase with pass_request shortening
                if (pass_request && !pass_req_latched && cnt > 8'd10) begin
                    // Shorten remaining green time to 10 clocks once
                    next_cnt = 8'd10;
                end else if (cnt == 0) begin
                    next_state = s2_yellow;
                    next_cnt = 8'd5;
                end
                // else count down normally (default)
            end

            s2_yellow: begin
                // Yellow for 5 clocks
                if (cnt == 0) begin
                    next_state = s1_red;
                    next_cnt = 8'd10;
                end
            end

            default: begin
                next_state = idle;
                next_cnt = 8'd0;
            end
        endcase
    end

    // Output logic depends directly on current state
    always @(*) begin
        red    = (state == s1_red);
        yellow = (state == s2_yellow);
        green  = (state == s3_green);
    end

    // Output clock is current counter value
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clock <= 8'd0;
        else
            clock <= cnt;
    end

endmodule