module traffic_light (
    input        rst_n,
    input        clk,
    input        pass_request,
    output reg [7:0] clock,
    output       red,
    output       yellow,
    output       green
);

    // State encoding using localparams (2 bits)
    localparam idle      = 2'd0;
    localparam s1_red    = 2'd1;
    localparam s2_yellow = 2'd2;
    localparam s3_green  = 2'd3;

    // Timing constants for each state (in clock cycles)
    localparam RED_TIME    = 8'd10;
    localparam YELLOW_TIME = 8'd5;
    localparam GREEN_TIME  = 8'd60;
    localparam GREEN_SHORT = 8'd10;

    reg [1:0] state, next_state;
    reg [7:0] cnt, next_cnt;

    // Sequential logic: state and counter update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= idle;
            cnt <= 8'd0;
            clock <= 8'd0;
        end else begin
            state <= next_state;
            cnt <= next_cnt;
            clock <= next_cnt;
        end
    end

    // Combinational logic: next state and next counter calculation
    always @(*) begin
        // Default assignments to hold current values
        next_state = state;
        next_cnt = cnt;

        case(state)
            idle: begin
                // Immediately transition to s1_red with initial red count
                next_state = s1_red;
                next_cnt = RED_TIME;
            end

            s1_red: begin
                // Count down red timer
                if (cnt == 0) begin
                    next_state = s3_green;
                    next_cnt = GREEN_TIME;
                end else begin
                    next_cnt = cnt - 1;
                end
            end

            s2_yellow: begin
                // Count down yellow timer
                if (cnt == 0) begin
                    next_state = s1_red;
                    next_cnt = RED_TIME;
                end else begin
                    next_cnt = cnt - 1;
                end
            end

            s3_green: begin
                // Handle pedestrian button to shorten green time if needed
                if (pass_request && (cnt > GREEN_SHORT)) begin
                    next_cnt = GREEN_SHORT - 1; // shortens green to 10 cycles total (including current)
                end else if (cnt == 0) begin
                    next_state = s2_yellow;
                    next_cnt = YELLOW_TIME;
                end else begin
                    next_cnt = cnt - 1;
                end
            end

            default: begin
                // Default fallback to idle
                next_state = idle;
                next_cnt = 8'd0;
            end
        endcase
    end

    // Output logic: combinational outputs based on current state
    assign red    = (state == s1_red);
    assign yellow = (state == s2_yellow);
    assign green  = (state == s3_green);

endmodule