module traffic_light (
    input        rst_n,
    input        clk,
    input        pass_request,
    output reg [6:0] clock,
    output       red,
    output       yellow,
    output       green
);

    // Timing parameters (7 bits sufficient for max 60)
    localparam RED_TIME     = 7'd10;
    localparam YELLOW_TIME  = 7'd5;
    localparam GREEN_TIME   = 7'd60;
    localparam GREEN_SHORT  = 7'd10;

    // State encoding
    localparam RED    = 2'd0;
    localparam GREEN  = 2'd1;
    localparam YELLOW = 2'd2;

    // State and timer registers
    reg [1:0] state, next_state;
    reg [6:0] timer, next_timer;
    reg ped_shortened, next_ped_shortened;

    wire timer_en = (timer != 0);

    // Sequential logic: state, timer, and ped_shortened registers
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state         <= RED;
            timer         <= RED_TIME;
            ped_shortened <= 1'b0;
        end else begin
            state         <= next_state;
            timer         <= next_timer;
            ped_shortened <= next_ped_shortened;
        end
    end

    // Next state logic based on timer expiration
    always @(*) begin
        case (state)
            RED:    next_state = (timer == 0) ? GREEN  : RED;
            GREEN:  next_state = (timer == 0) ? YELLOW : GREEN;
            YELLOW: next_state = (timer == 0) ? RED    : YELLOW;
            default: next_state = RED;
        endcase
    end

    // Timer and ped_shortened update logic
    always @(*) begin
        // Defaults
        next_timer = timer;
        next_ped_shortened = ped_shortened;

        if (state != next_state) begin
            // Reload timer and reset ped_shortened on state transitions
            case (next_state)
                RED: begin
                    next_timer = RED_TIME;
                    next_ped_shortened = 1'b0;
                end
                GREEN: begin
                    next_timer = GREEN_TIME;
                    next_ped_shortened = 1'b0;
                end
                YELLOW: begin
                    next_timer = YELLOW_TIME;
                    next_ped_shortened = 1'b0;
                end
                default: begin
                    next_timer = RED_TIME;
                    next_ped_shortened = 1'b0;
                end
            endcase
        end else begin
            // No state change, handle timer countdown and pass_request shortening
            if (state == GREEN) begin
                // Pedestrian request: shorten green time once per green phase if remaining > 10
                if (pass_request && !ped_shortened && (timer > GREEN_SHORT)) begin
                    next_timer = GREEN_SHORT;
                    next_ped_shortened = 1'b1;
                end else if (timer_en) begin
                    next_timer = timer - 1;
                end
                // else hold timer at zero until state transition
            end else begin
                // In RED or YELLOW states, just countdown timer if > 0
                if (timer_en)
                    next_timer = timer - 1;
                // else hold timer at zero until state transition
            end
        end
    end

    // Output assignment combinationally from current state
    assign red    = (state == RED);
    assign yellow = (state == YELLOW);
    assign green  = (state == GREEN);

    // Output clock value from timer register
    always @(*) begin
        clock = timer;
    end

endmodule