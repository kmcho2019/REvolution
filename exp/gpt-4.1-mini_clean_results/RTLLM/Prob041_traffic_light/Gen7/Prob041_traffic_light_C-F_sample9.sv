module traffic_light (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       pass_request,
    output reg  [7:0] clock,
    output reg        red,
    output reg        yellow,
    output reg        green
);

    // State encoding
    localparam IDLE    = 2'd0;
    localparam RED     = 2'd1;
    localparam GREEN   = 2'd2;
    localparam YELLOW  = 2'd3;

    // Timing constants
    localparam RED_TIME    = 8'd10;
    localparam YELLOW_TIME = 8'd5;
    localparam GREEN_TIME  = 8'd60;
    localparam GREEN_SHORT = 8'd10;

    reg [1:0] state, next_state;
    reg [7:0] cnt, next_cnt;

    // Next state and next count combinational logic
    always @(*) begin
        // Default assignments
        next_state = state;
        next_cnt = cnt;

        case(state)
            IDLE: begin
                // On reset, idle immediately transitions to RED with RED_TIME count
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
                end else if (pass_request && cnt > GREEN_SHORT) begin
                    // Shorten green time to 10 if pedestrian requests and remaining time > 10
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
                next_state = IDLE;
                next_cnt = RED_TIME;
            end
        endcase
    end

    // Sequential logic: update state and counter on clock, async reset active low
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
            clock <= next_cnt;

            // Output logic based on state
            case (next_state)
                IDLE: begin
                    red    <= 1'b0;
                    yellow <= 1'b0;
                    green  <= 1'b0;
                end
                RED: begin
                    red    <= 1'b1;
                    yellow <= 1'b0;
                    green  <= 1'b0;
                end
                GREEN: begin
                    red    <= 1'b0;
                    yellow <= 1'b0;
                    green  <= 1'b1;
                end
                YELLOW: begin
                    red    <= 1'b0;
                    yellow <= 1'b1;
                    green  <= 1'b0;
                end
                default: begin
                    red    <= 1'b0;
                    yellow <= 1'b0;
                    green  <= 1'b0;
                end
            endcase
        end
    end

endmodule