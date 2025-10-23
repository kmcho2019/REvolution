module traffic_light(
    input        rst_n,
    input        clk,
    input        pass_request,
    output reg [7:0] clock,
    output       red,
    output       yellow,
    output       green
);

    // State encoding
    typedef enum logic [1:0] {
        S_RED    = 2'b00,
        S_GREEN  = 2'b01,
        S_YELLOW = 2'b10
    } state_t;

    // Timing constants
    localparam int RED_TIME     = 8'd10;
    localparam int YELLOW_TIME  = 8'd5;
    localparam int GREEN_TIME   = 8'd60;
    localparam int GREEN_SHORT  = 8'd10;

    state_t state, next_state;
    reg [7:0] timer, next_timer;

    // ped_shortened flag indicates if green was shortened in current green cycle
    reg ped_shortened, next_ped_shortened;

    // Next state logic (combinational)
    always @(*) begin
        next_state = state;
        if (timer == 0) begin
            case (state)
                S_RED:    next_state = S_GREEN;
                S_GREEN:  next_state = S_YELLOW;
                S_YELLOW: next_state = S_RED;
                default:  next_state = S_RED;
            endcase
        end
    end

    // Next timer logic (combinational)
    always @(*) begin
        next_timer = timer;
        case (state)
            S_RED: begin
                if (timer == 0)
                    next_timer = GREEN_TIME;
                else
                    next_timer = timer - 1;
            end
            S_GREEN: begin
                if (timer == 0)
                    next_timer = YELLOW_TIME;
                else if (pass_request && !ped_shortened && (timer > GREEN_SHORT))
                    next_timer = GREEN_SHORT;
                else
                    next_timer = timer - 1;
            end
            S_YELLOW: begin
                if (timer == 0)
                    next_timer = RED_TIME;
                else
                    next_timer = timer - 1;
            end
            default: next_timer = RED_TIME;
        endcase
    end

    // ped_shortened flag logic (combinational)
    always @(*) begin
        next_ped_shortened = ped_shortened;
        if (state != S_GREEN)
            next_ped_shortened = 1'b0; // Reset when leaving green
        else if (pass_request && !ped_shortened && (timer > GREEN_SHORT))
            next_ped_shortened = 1'b1; // Set when shortening green
    end

    // State, timer and ped_shortened registers (sequential)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= S_RED;
            timer <= RED_TIME;
            ped_shortened <= 1'b0;
        end else begin
            state <= next_state;
            timer <= next_timer;
            ped_shortened <= next_ped_shortened;
        end
    end

    // Output logic (combinational)
    assign red    = (state == S_RED);
    assign yellow = (state == S_YELLOW);
    assign green  = (state == S_GREEN);

    // clock output assignment
    always @(*) begin
        clock = timer;
    end

endmodule