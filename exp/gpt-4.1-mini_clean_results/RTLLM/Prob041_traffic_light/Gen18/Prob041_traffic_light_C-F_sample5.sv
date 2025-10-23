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
    localparam [1:0]
        RED    = 2'b00,
        GREEN  = 2'b01,
        YELLOW = 2'b10;

    // Timing parameters
    localparam [7:0]
        RED_TIME    = 8'd10,
        YELLOW_TIME = 8'd5,
        GREEN_TIME  = 8'd60,
        SHORT_GREEN = 8'd10;

    reg [1:0] state, next_state;
    reg [7:0] timer, next_timer;
    reg ped_shortened, next_ped_shortened;

    // Synchronous state, timer, and ped_shortened update
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

    // Combinational next-state, next-timer, ped_shortened logic
    always @(*) begin
        // Default assignments to current values
        next_state         = state;
        next_timer         = timer;
        next_ped_shortened = ped_shortened;

        case (state)
            RED: begin
                if (timer == 0) begin
                    next_state         = GREEN;
                    next_timer         = GREEN_TIME;
                    next_ped_shortened = 1'b0;
                end else begin
                    if (timer != 0)
                        next_timer = timer - 1;
                end
            end

            GREEN: begin
                // On pedestrian request, shorten green if > SHORT_GREEN and not shortened yet
                if (pass_request && (timer > SHORT_GREEN) && !ped_shortened) begin
                    next_timer         = SHORT_GREEN;
                    next_ped_shortened = 1'b1;
                    // Stay in GREEN state
                    next_state = GREEN;
                end else if (timer == 0) begin
                    next_state         = YELLOW;
                    next_timer         = YELLOW_TIME;
                    next_ped_shortened = 1'b0;
                end else begin
                    if (timer != 0)
                        next_timer = timer - 1;
                end
            end

            YELLOW: begin
                if (timer == 0) begin
                    next_state         = RED;
                    next_timer         = RED_TIME;
                    next_ped_shortened = 1'b0;
                end else begin
                    if (timer != 0)
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

    // Outputs combinational from state and timer
    assign red    = (state == RED);
    assign yellow = (state == YELLOW);
    assign green  = (state == GREEN);
    assign clock  = timer;

endmodule