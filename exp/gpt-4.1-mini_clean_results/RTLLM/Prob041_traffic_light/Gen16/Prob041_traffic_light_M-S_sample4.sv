module traffic_light (
    input        rst_n,
    input        clk,
    input        pass_request,
    output reg [7:0] clock,
    output reg   red,
    output reg   yellow,
    output reg   green
);

    // State encoding
    localparam IDLE     = 2'd0;
    localparam RED      = 2'd1;
    localparam YELLOW   = 2'd2;
    localparam GREEN    = 2'd3;

    // Timing parameters
    localparam RED_TIME    = 8'd10;
    localparam YELLOW_TIME = 8'd5;
    localparam GREEN_TIME  = 8'd60;
    localparam GREEN_SHORT = 8'd10;

    reg [1:0] state, next_state;
    reg [7:0] cnt, next_cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            cnt <= 8'd0;
            red <= 1'b0;
            yellow <= 1'b0;
            green <= 1'b0;
            clock <= 8'd0;
        end else begin
            state <= next_state;
            cnt <= next_cnt;

            // Output signals reflect current state
            red <= (next_state == RED);
            yellow <= (next_state == YELLOW);
            green <= (next_state == GREEN);

            clock <= next_cnt;
        end
    end

    // Next state and counter logic
    always @(*) begin
        next_state = state;
        next_cnt = cnt;

        case (state)
            IDLE: begin
                // Immediately go to RED state with RED_TIME count
                next_state = RED;
                next_cnt = RED_TIME;
            end

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
                end else begin
                    // If pedestrian pressed and remaining green > 10, shorten to 10
                    if (pass_request && cnt > GREEN_SHORT)
                        next_cnt = GREEN_SHORT;
                    else
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
                next_state = IDLE;
                next_cnt = 8'd0;
            end
        endcase
    end

endmodule