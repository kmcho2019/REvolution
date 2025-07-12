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
    typedef enum reg [1:0] {
        IDLE   = 2'b00,
        RED    = 2'b01,
        GREEN  = 2'b10,
        YELLOW = 2'b11
    } state_t;

    localparam [7:0] RED_TIME    = 8'd10;
    localparam [7:0] YELLOW_TIME = 8'd5;
    localparam [7:0] GREEN_TIME  = 8'd60;
    localparam [7:0] SHORT_GREEN = 8'd10;

    reg [7:0] timer;
    reg [7:0] next_timer;
    state_t state, next_state;

    // Sequential state and timer update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            timer <= 8'd0;
        end else begin
            state <= next_state;
            timer <= next_timer;
        end
    end

    // Combinational logic for next state and timer
    always @(*) begin
        // Default next values
        next_state = state;
        next_timer = timer;

        case(state)
            IDLE: begin
                // On reset, go to RED immediately with red timer
                next_state = RED;
                next_timer = RED_TIME;
            end
            RED: begin
                if (timer == 0) begin
                    next_state = GREEN;
                    next_timer = GREEN_TIME;
                end else begin
                    next_timer = timer - 1;
                end
            end
            GREEN: begin
                // Pedestrian request shortens green time if > 10
                if (pass_request && (timer > SHORT_GREEN))
                    next_timer = SHORT_GREEN;
                else if (timer == 0) begin
                    next_state = YELLOW;
                    next_timer = YELLOW_TIME;
                end else begin
                    // decrement timer if no shortening condition
                    next_timer = timer - 1;
                end
            end
            YELLOW: begin
                if (timer == 0) begin
                    next_state = RED;
                    next_timer = RED_TIME;
                end else begin
                    next_timer = timer - 1;
                end
            end
            default: begin
                next_state = IDLE;
                next_timer = 8'd0;
            end
        endcase
    end

    // Output logic registered on clock edge for output stability
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            red    <= 1'b0;
            yellow <= 1'b0;
            green  <= 1'b0;
            clock  <= 8'd0;
        end else begin
            red    <= (state == RED);
            yellow <= (state == YELLOW);
            green  <= (state == GREEN);
            clock  <= timer;
        end
    end

endmodule