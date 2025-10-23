module traffic_light (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       pass_request,
    output wire [7:0] clock,
    output wire       red,
    output wire       yellow,
    output wire       green
);

    // State encoding
    typedef enum logic [1:0] {
        IDLE   = 2'd0,
        RED    = 2'd1,
        YELLOW = 2'd2,
        GREEN  = 2'd3
    } state_t;

    localparam [7:0] RED_TIME    = 8'd10;
    localparam [7:0] YELLOW_TIME = 8'd5;
    localparam [7:0] GREEN_TIME  = 8'd60;
    localparam [7:0] SHORT_GREEN = 8'd10;

    state_t state, next_state;
    reg [7:0] timer, next_timer;

    // Next state and next timer combinational logic
    always @(*) begin
        next_state = state;
        next_timer = timer;

        if (timer == 0) begin
            case (state)
                RED: begin
                    next_state = GREEN;
                    next_timer = GREEN_TIME;
                end
                GREEN: begin
                    next_state = YELLOW;
                    next_timer = YELLOW_TIME;
                end
                YELLOW: begin
                    next_state = RED;
                    next_timer = RED_TIME;
                end
                default: begin
                    next_state = RED;
                    next_timer = RED_TIME;
                end
            endcase
        end else begin
            // If green and pass_request and timer > SHORT_GREEN, shorten timer
            if (state == GREEN && pass_request && timer > SHORT_GREEN)
                next_timer = SHORT_GREEN;
            else
                next_timer = timer - 1;
        end
    end

    // State and timer registers sequential logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= RED;
            timer <= RED_TIME;
        end else begin
            state <= next_state;
            timer <= next_timer;
        end
    end

    // Output logic combinational
    assign red    = (state == RED);
    assign yellow = (state == YELLOW);
    assign green  = (state == GREEN);
    assign clock  = timer;

endmodule