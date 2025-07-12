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
    localparam IDLE      = 2'd0;
    localparam RED       = 2'd1;
    localparam YELLOW    = 2'd2;
    localparam GREEN     = 2'd3;

    // Timing constants
    localparam RED_TIME    = 8'd10;
    localparam YELLOW_TIME = 8'd5;
    localparam GREEN_TIME  = 8'd60;
    localparam GREEN_SHORT = 8'd10;

    reg [7:0] cnt;
    reg [1:0] state, next_state;

    // Counter reload value for each state
    reg [7:0] cnt_reload;

    // Counter enable signal
    reg cnt_en;

    // Next counter value logic
    reg [7:0] cnt_next;

    // State machine next state logic
    always @(*) begin
        next_state = state;
        cnt_reload = 8'd0;
        cnt_en = 1'b0;

        case(state)
            IDLE: begin
                // Immediately transition to RED state with reload
                next_state = RED;
                cnt_reload = RED_TIME;
                cnt_en = 1'b0; // will load counter on next clock
            end

            RED: begin
                cnt_en = 1'b1;
                if (cnt == 8'd0) begin
                    next_state = GREEN;
                    cnt_reload = GREEN_TIME;
                    cnt_en = 1'b0; // reload counter next clock
                end
            end

            GREEN: begin
                cnt_en = 1'b1;
                if (cnt == 8'd0) begin
                    next_state = YELLOW;
                    cnt_reload = YELLOW_TIME;
                    cnt_en = 1'b0; // reload counter next clock
                end
            end

            YELLOW: begin
                cnt_en = 1'b1;
                if (cnt == 8'd0) begin
                    next_state = RED;
                    cnt_reload = RED_TIME;
                    cnt_en = 1'b0; // reload counter next clock
                end
            end

            default: begin
                next_state = IDLE;
                cnt_reload = RED_TIME;
                cnt_en = 1'b0;
            end
        endcase
    end

    // State register update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Counter logic with reload and decrement, including pedestrian button handling
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= RED_TIME;
        end else begin
            // Counter reload takes precedence
            if (cnt_en == 1'b0) begin
                // Reload counter when cnt_en low (state change)
                cnt <= cnt_reload;
            end else begin
                // If in GREEN state and pass_request is asserted and remaining time > 10, shorten counter to 10
                if ((state == GREEN) && pass_request && (cnt > GREEN_SHORT)) begin
                    cnt <= GREEN_SHORT;
                end else if (cnt != 0) begin
                    // Normal countdown
                    cnt <= cnt - 1;
                end
                // If cnt == 0, counter remains zero until state transition reloads it
            end
        end
    end

    // Output logic derived directly from state (one-hot encoding)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            red    <= 1'b0;
            yellow <= 1'b0;
            green  <= 1'b0;
        end else begin
            case(state)
                RED: begin
                    red    <= 1'b1;
                    yellow <= 1'b0;
                    green  <= 1'b0;
                end
                YELLOW: begin
                    red    <= 1'b0;
                    yellow <= 1'b1;
                    green  <= 1'b0;
                end
                GREEN: begin
                    red    <= 1'b0;
                    yellow <= 1'b0;
                    green  <= 1'b1;
                end
                default: begin
                    red    <= 1'b0;
                    yellow <= 1'b0;
                    green  <= 1'b0;
                end
            endcase
        end
    end

    assign clock = cnt;

endmodule