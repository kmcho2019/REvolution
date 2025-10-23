module traffic_light (
    input        rst_n,
    input        clk,
    input        pass_request,
    output [7:0] clock,
    output       red,
    output       yellow,
    output       green
);

    // Timing parameters
    localparam RED_TIME    = 8'd10;
    localparam YELLOW_TIME = 8'd5;
    localparam GREEN_TIME  = 8'd60;
    localparam GREEN_SHORT = 8'd10;

    // One-hot encoded states
    reg red_state, yellow_state, green_state;
    reg [7:0] cnt, next_cnt;

    // State flip-flops update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            red_state    <= 1'b1;
            yellow_state <= 1'b0;
            green_state  <= 1'b0;
            cnt          <= RED_TIME;
        end else begin
            red_state    <= (red_state)    ? (cnt != 0 ? 1'b1 : 1'b0) : 
                             (yellow_state && cnt == 0) ? 1'b1 : 1'b0;
            yellow_state <= (yellow_state) ? (cnt != 0 ? 1'b1 : 1'b0) : 
                             (green_state && cnt == 0) ? 1'b1 : 1'b0;
            green_state  <= (green_state)  ? (cnt != 0 ? 1'b1 : 1'b0) : 
                             (red_state && cnt == 0) ? 1'b1 : 1'b0;
            cnt          <= next_cnt;
        end
    end

    // Next counter value logic
    always @(*) begin
        if (red_state) begin
            if (cnt == 0)
                next_cnt = GREEN_TIME;
            else
                next_cnt = cnt - 1;
        end else if (green_state) begin
            if (cnt == 0)
                next_cnt = YELLOW_TIME;
            else if (pass_request && (cnt > GREEN_SHORT))
                next_cnt = GREEN_SHORT;
            else
                next_cnt = cnt - 1;
        end else if (yellow_state) begin
            if (cnt == 0)
                next_cnt = RED_TIME;
            else
                next_cnt = cnt - 1;
        end else begin
            // Default to red state timing if somehow no state active
            next_cnt = RED_TIME;
        end
    end

    // Outputs assigned combinationally from one-hot state bits
    assign red    = red_state;
    assign yellow = yellow_state;
    assign green  = green_state;

    // Output current counter value
    assign clock = cnt;

endmodule