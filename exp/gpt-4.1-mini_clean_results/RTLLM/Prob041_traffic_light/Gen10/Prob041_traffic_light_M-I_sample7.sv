module traffic_light (
    input wire rst_n,
    input wire clk,
    input wire pass_request,
    output reg [7:0] clock,
    output reg red,
    output reg yellow,
    output reg green
);

localparam RED    = 2'd0;
localparam GREEN  = 2'd1;
localparam YELLOW = 2'd2;

localparam RED_TIME    = 8'd10;
localparam YELLOW_TIME = 8'd5;
localparam GREEN_TIME  = 8'd60;
localparam SHORT_GREEN = 8'd10;

reg [1:0] state;
reg [7:0] timer;
reg red_r, yellow_r, green_r;

wire timer_enable = (timer != 0);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= RED;
        timer <= RED_TIME;
        red_r <= 1'b1;
        yellow_r <= 1'b0;
        green_r <= 1'b0;
        clock <= RED_TIME;
    end else begin
        // State transitions
        if (timer == 0) begin
            case (state)
                RED: state <= GREEN;
                GREEN: state <= YELLOW;
                YELLOW: state <= RED;
                default: state <= RED;
            endcase
            case (state)
                RED: timer <= GREEN_TIME;
                GREEN: timer <= YELLOW_TIME;
                YELLOW: timer <= RED_TIME;
                default: timer <= RED_TIME;
            endcase
        end else begin
            // Timer control: shorten green if requested
            if (state == GREEN && pass_request && timer > SHORT_GREEN)
                timer <= SHORT_GREEN;
            else if (timer_enable)
                timer <= timer - 1;
        end

        // Outputs registered with state
        red_r <= (state == RED);
        yellow_r <= (state == YELLOW);
        green_r <= (state == GREEN);

        // Clock output registered for stable timing
        clock <= timer;
    end
end

// Outputs assigned from registered signals for improved timing
always @(*) begin
    red = red_r;
    yellow = yellow_r;
    green = green_r;
end

endmodule