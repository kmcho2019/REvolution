module traffic_light (
    input        rst_n,
    input        clk,
    input        pass_request,
    output reg [7:0] clock,
    output       red,
    output       yellow,
    output       green
);

    // Timing parameters
    localparam integer RED_TIME    = 8'd10;
    localparam integer YELLOW_TIME = 8'd5;
    localparam integer GREEN_TIME  = 8'd60;
    localparam integer GREEN_SHORT = 8'd10;

    // One-hot state encoding
    reg s_red;
    reg s_yellow;
    reg s_green;

    // Counter register
    reg [7:0] cnt;

    // Next state signals for one-hot encoding
    reg next_s_red;
    reg next_s_yellow;
    reg next_s_green;

    // Next counter value
    reg [7:0] next_cnt;

    // State machine combinational logic
    always @(*) begin
        // Default next states same as current
        next_s_red = s_red;
        next_s_yellow = s_yellow;
        next_s_green = s_green;
        next_cnt = cnt;

        if (s_red) begin
            if (cnt == 0) begin
                // Transition RED -> GREEN
                next_s_red = 1'b0;
                next_s_green = 1'b1;
                next_cnt = GREEN_TIME;
            end else begin
                next_cnt = cnt - 1;
            end
        end else if (s_green) begin
            if (cnt == 0) begin
                // Transition GREEN -> YELLOW
                next_s_green = 1'b0;
                next_s_yellow = 1'b1;
                next_cnt = YELLOW_TIME;
            end else if (pass_request && (cnt > GREEN_SHORT)) begin
                // Pedestrian button shortens green time if more than 10 cycles remain
                next_cnt = GREEN_SHORT;
            end else begin
                next_cnt = cnt - 1;
            end
        end else if (s_yellow) begin
            if (cnt == 0) begin
                // Transition YELLOW -> RED
                next_s_yellow = 1'b0;
                next_s_red = 1'b1;
                next_cnt = RED_TIME;
            end else begin
                next_cnt = cnt - 1;
            end
        end else begin
            // If no state active (reset state), start at RED
            next_s_red = 1'b1;
            next_cnt = RED_TIME;
        end
    end

    // Sequential logic to update state and counter
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            s_red <= 1'b1;
            s_yellow <= 1'b0;
            s_green <= 1'b0;
            cnt <= RED_TIME;
        end else begin
            s_red <= next_s_red;
            s_yellow <= next_s_yellow;
            s_green <= next_s_green;
            cnt <= next_cnt;
        end
    end

    // Outputs driven by state signals
    assign red    = s_red;
    assign yellow = s_yellow;
    assign green  = s_green;

    // Output clock assigned from counter register synchronously
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clock <= 8'd0;
        else
            clock <= cnt;
    end

endmodule