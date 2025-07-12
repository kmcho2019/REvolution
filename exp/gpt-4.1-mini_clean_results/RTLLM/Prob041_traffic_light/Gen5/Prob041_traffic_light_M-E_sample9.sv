module traffic_light (
    input        rst_n,
    input        clk,
    input        pass_request,
    output reg [7:0] clock,
    output       red,
    output       yellow,
    output       green
);

    // State encoding
    localparam [1:0]
        RED    = 2'b00,
        GREEN  = 2'b01,
        YELLOW = 2'b10;

    // Time durations
    localparam [7:0]
        RED_TIME    = 8'd10,
        YELLOW_TIME = 8'd5,
        GREEN_TIME  = 8'd60,
        GREEN_MIN   = 8'd10;

    reg [1:0] state, next_state;
    reg [7:0] timer, next_timer;

    // State register and timer register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= RED;
            timer <= RED_TIME;
        end else begin
            state <= next_state;
            timer <= next_timer;
        end
    end

    // Next state and timer logic
    always @(*) begin
        // Default assignments to hold state and decrement timer
        next_state = state;
        next_timer = (timer > 0) ? timer - 1 : 8'd0;

        case (state)
            RED: begin
                if (timer == 0) begin
                    next_state = GREEN;
                    next_timer = GREEN_TIME - 1;
                end
            end
            GREEN: begin
                if (timer == 0) begin
                    next_state = YELLOW;
                    next_timer = YELLOW_TIME - 1;
                end else if (pass_request && (timer > GREEN_MIN)) begin
                    // Shorten green time if request and remaining time > 10
                    next_timer = GREEN_MIN - 1;
                end
            end
            YELLOW: begin
                if (timer == 0) begin
                    next_state = RED;
                    next_timer = RED_TIME - 1;
                end
            end
            default: begin
                next_state = RED;
                next_timer = RED_TIME - 1;
            end
        endcase
    end

    // Outputs reflect current state (Moore outputs)
    assign red    = (state == RED);
    assign green  = (state == GREEN);
    assign yellow = (state == YELLOW);

    // Output the current timer
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) clock <= RED_TIME;
        else clock <= timer;
    end

endmodule