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
        RED    = 2'd0,
        GREEN  = 2'd1,
        YELLOW = 2'd2;

    // Timing constants
    localparam [7:0]
        RED_TIME    = 8'd10,
        YELLOW_TIME = 8'd5,
        GREEN_TIME  = 8'd60,
        SHORT_GREEN = 8'd10;

    reg [1:0] state, next_state;
    reg [7:0] timer, next_timer;
    reg ped_shortened, next_ped_shortened;

    // State and timer update
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

    // Next state and timer logic
    always @(*) begin
        next_state         = state;
        next_timer         = timer;
        next_ped_shortened = ped_shortened;

        case (state)
            RED: begin
                if (timer == 8'd0) begin
                    next_state         = GREEN;
                    next_timer         = GREEN_TIME;
                    next_ped_shortened = 1'b0;
                end else begin
                    next_timer = timer - 1;
                end
            end

            GREEN: begin
                if (pass_request && (timer > SHORT_GREEN) && !ped_shortened) begin
                    next_timer         = SHORT_GREEN;
                    next_ped_shortened = 1'b1;
                end else if (timer == 8'd0) begin
                    next_state         = YELLOW;
                    next_timer         = YELLOW_TIME;
                    next_ped_shortened = 1'b0;
                end else begin
                    next_timer = timer - 1;
                end
            end

            YELLOW: begin
                if (timer == 8'd0) begin
                    next_state         = RED;
                    next_timer         = RED_TIME;
                    next_ped_shortened = 1'b0;
                end else begin
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

    // Outputs combinationally from state
    assign red    = (state == RED);
    assign green  = (state == GREEN);
    assign yellow = (state == YELLOW);
    assign clock  = timer;

endmodule