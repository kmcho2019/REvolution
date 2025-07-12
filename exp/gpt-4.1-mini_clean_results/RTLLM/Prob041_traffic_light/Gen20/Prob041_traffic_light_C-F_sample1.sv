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
    localparam [1:0]
        RED    = 2'b00,
        GREEN  = 2'b01,
        YELLOW = 2'b10;

    // Timing parameters (7 bits, max count 60)
    localparam [6:0]
        RED_TIME    = 7'd10,
        YELLOW_TIME = 7'd5,
        GREEN_TIME  = 7'd60,
        SHORT_GREEN = 7'd10;

    reg [1:0] state, next_state;
    reg [6:0] timer, next_timer;
    reg       ped_shortened, next_ped_shortened;

    wire timer_en = (timer != 7'd0);

    // Sequential: state, timer, and ped_shortened update
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

    // Combinational: next state, timer, and ped_shortened logic
    always @(*) begin
        next_state         = state;
        next_timer         = timer;
        next_ped_shortened = ped_shortened;

        case (state)
            RED: begin
                if (timer == 7'd0) begin
                    next_state         = GREEN;
                    next_timer         = GREEN_TIME;
                    next_ped_shortened = 1'b0;
                end else if (timer_en) begin
                    next_timer = timer - 1;
                end
            end

            GREEN: begin
                // Pedestrian request and green time left > SHORT_GREEN and not yet shortened?
                if (pass_request && (timer > SHORT_GREEN) && !ped_shortened) begin
                    next_timer         = SHORT_GREEN;
                    next_state         = GREEN; // remain GREEN while timer counts down
                    next_ped_shortened = 1'b1;
                end else if (timer == 7'd0) begin
                    next_state         = YELLOW;
                    next_timer         = YELLOW_TIME;
                    next_ped_shortened = 1'b0;  // reset for next cycle
                end else if (timer_en) begin
                    next_timer = timer - 1;
                end
            end

            YELLOW: begin
                if (timer == 7'd0) begin
                    next_state         = RED;
                    next_timer         = RED_TIME;
                    next_ped_shortened = 1'b0;
                end else if (timer_en) begin
                    next_timer = timer - 1;
                end
            end

            default: begin
                next_state         = RED;
                next_timer         = RED_TIME;
                next_ped_shortened = 1'b0;
            end
        endcase
    end

    // Outputs derived combinationally from current state and zero-extended timer
    always @(*) begin
        red    = (state == RED);
        yellow = (state == YELLOW);
        green  = (state == GREEN);
        clock  = {1'b0, timer};  // zero-extend 7-bit timer to 8 bits
    end

endmodule