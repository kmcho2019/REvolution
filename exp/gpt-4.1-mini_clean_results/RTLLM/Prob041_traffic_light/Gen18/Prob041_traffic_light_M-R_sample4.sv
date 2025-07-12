module traffic_light (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       pass_request,
    output wire [7:0] clock,
    output wire       red,
    output wire       yellow,
    output wire       green
);

    // State definitions
    localparam [1:0] 
        IDLE   = 2'b00,
        S1_RED = 2'b01,
        S2_YELLOW = 2'b10,
        S3_GREEN = 2'b11;

    // Timing parameters
    localparam [7:0] RED_TIME    = 8'd10;
    localparam [7:0] YELLOW_TIME = 8'd5;
    localparam [7:0] GREEN_TIME  = 8'd60;
    localparam [7:0] SHORT_GREEN = 8'd10;

    reg [7:0] cnt;
    reg [1:0] state, next_state;
    reg [7:0] next_cnt;

    // Combinational next state and next count logic
    always @(*) begin
        next_state = state;
        next_cnt = cnt;

        case (state)
            IDLE: begin
                // Immediately transition to s1_red with timer set to RED_TIME
                next_state = S1_RED;
                next_cnt = RED_TIME;
            end

            S1_RED: begin
                // Red light on, count down
                if (cnt == 0) begin
                    next_state = S3_GREEN;
                    next_cnt = GREEN_TIME;
                end else begin
                    next_cnt = cnt - 1;
                end
            end

            S2_YELLOW: begin
                // Yellow light on, count down
                if (cnt == 0) begin
                    next_state = S1_RED;
                    next_cnt = RED_TIME;
                end else begin
                    next_cnt = cnt - 1;
                end
            end

            S3_GREEN: begin
                // Green light on
                if (pass_request && (cnt > SHORT_GREEN)) begin
                    // Pedestrian pressed and green time > 10, shorten green time
                    next_cnt = SHORT_GREEN;
                end else if (cnt == 0) begin
                    next_state = S2_YELLOW;
                    next_cnt = YELLOW_TIME;
                end else begin
                    next_cnt = cnt - 1;
                end
            end

            default: begin
                // Fallback to IDLE state
                next_state = IDLE;
                next_cnt = 8'd0;
            end
        endcase
    end

    // Sequential state and count update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            cnt <= 8'd0;
        end else begin
            state <= next_state;
            cnt <= next_cnt;
        end
    end

    // Output logic: Moore outputs depend only on the current state
    assign red    = (state == S1_RED);
    assign yellow = (state == S2_YELLOW);
    assign green  = (state == S3_GREEN);
    assign clock  = cnt;

endmodule