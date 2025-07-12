module traffic_light (
    input        rst_n,
    input        clk,
    input        pass_request,
    output reg [7:0] clock,
    output reg   red,
    output reg   yellow,
    output reg   green
);

    // Timing parameters
    localparam IDLE      = 2'd0;
    localparam RED       = 2'd1;
    localparam YELLOW    = 2'd2;
    localparam GREEN     = 2'd3;

    localparam RED_TIME    = 8'd10;
    localparam YELLOW_TIME = 8'd5;
    localparam GREEN_TIME  = 8'd60;
    localparam GREEN_SHORT = 8'd10;

    reg [1:0] state, next_state;
    reg [7:0] timer, next_timer;
    reg [7:0] max_timer;  // max count for current state, can be adjusted dynamically in green

    // State transition and timer update logic (Mealy FSM)
    always @(*) begin
        // Defaults: stay in same state, increment timer if not reached max
        next_state = state;
        next_timer = timer;
        max_timer = 0;

        case (state)
            IDLE: begin
                // On reset release, move immediately to RED with timer reset
                next_state = RED;
                next_timer = 0;
                max_timer = RED_TIME;
            end
            RED: begin
                max_timer = RED_TIME;
                if (timer >= max_timer) begin
                    next_state = GREEN;
                    next_timer = 0;
                end else begin
                    next_timer = timer + 1;
                end
            end
            YELLOW: begin
                max_timer = YELLOW_TIME;
                if (timer >= max_timer) begin
                    next_state = RED;
                    next_timer = 0;
                end else begin
                    next_timer = timer + 1;
                end
            end
            GREEN: begin
                // Default max_timer is GREEN_TIME
                max_timer = GREEN_TIME;
                // Adjust max_timer if pass_request asserted and remaining green time > 10
                // remaining time = GREEN_TIME - timer
                if (pass_request && ((GREEN_TIME - timer) > GREEN_SHORT)) begin
                    max_timer = timer + GREEN_SHORT; // shortens the green to timer + 10 cycles total
                end
                if (timer >= max_timer) begin
                    next_state = YELLOW;
                    next_timer = 0;
                end else begin
                    next_timer = timer + 1;
                end
            end
            default: begin
                next_state = IDLE;
                next_timer = 0;
                max_timer = 0;
            end
        endcase
    end

    // Synchronous state and timer update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            timer <= 0;
        end else begin
            state <= next_state;
            timer <= next_timer;
        end
    end

    // Output logic registered synchronously for glitch-free signals
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            red <= 1'b0;
            yellow <= 1'b0;
            green <= 1'b0;
        end else begin
            case (next_state)
                IDLE: begin
                    red <= 1'b0;
                    yellow <= 1'b0;
                    green <= 1'b0;
                end
                RED: begin
                    red <= 1'b1;
                    yellow <= 1'b0;
                    green <= 1'b0;
                end
                YELLOW: begin
                    red <= 1'b0;
                    yellow <= 1'b1;
                    green <= 1'b0;
                end
                GREEN: begin
                    red <= 1'b0;
                    yellow <= 1'b0;
                    green <= 1'b1;
                end
                default: begin
                    red <= 1'b0;
                    yellow <= 1'b0;
                    green <= 1'b0;
                end
            endcase
        end
    end

    // Output current timer count
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clock <= 8'd0;
        else
            clock <= timer;
    end

endmodule