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

    // State encoding
    localparam RED    = 2'd0;
    localparam GREEN  = 2'd1;
    localparam YELLOW = 2'd2;

    reg [1:0] state, next_state;
    reg [7:0] cnt, next_cnt;

    // State register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= RED;
        else
            state <= next_state;
    end

    // Counter register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt <= RED_TIME;
        else
            cnt <= next_cnt;
    end

    // Next state and counter combinational logic
    always @(*) begin
        next_state = state;
        next_cnt = cnt;

        case (state)
            RED: begin
                if (cnt == 0) begin
                    next_state = GREEN;
                    next_cnt = GREEN_TIME;
                end else begin
                    next_cnt = cnt - 1;
                end
            end

            GREEN: begin
                if (cnt == 0) begin
                    next_state = YELLOW;
                    next_cnt = YELLOW_TIME;
                end else if (pass_request && (cnt > GREEN_SHORT)) begin
                    // Shorten green time if pedestrian requests and remaining green > 10
                    next_cnt = GREEN_SHORT;
                end else begin
                    next_cnt = cnt - 1;
                end
            end

            YELLOW: begin
                if (cnt == 0) begin
                    next_state = RED;
                    next_cnt = RED_TIME;
                end else begin
                    next_cnt = cnt - 1;
                end
            end

            default: begin
                next_state = RED;
                next_cnt = RED_TIME;
            end
        endcase
    end

    // Outputs assigned directly from state (combinational)
    assign red    = (state == RED);
    assign yellow = (state == YELLOW);
    assign green  = (state == GREEN);

    // Output current count
    assign clock = cnt;

endmodule