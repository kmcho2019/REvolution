module traffic_light (
    input        rst_n,
    input        clk,
    input        pass_request,
    output reg [7:0] clock,
    output reg   red,
    output reg   yellow,
    output reg   green
);

    // State encoding
    localparam IDLE   = 2'd0;
    localparam RED    = 2'd1;
    localparam GREEN  = 2'd2;
    localparam YELLOW = 2'd3;

    // Timing constants
    localparam RED_TIME    = 8'd10;
    localparam YELLOW_TIME = 8'd5;
    localparam GREEN_TIME  = 8'd60;
    localparam GREEN_SHORT = 8'd10;

    reg [1:0] state, next_state;
    reg [7:0] timer, next_timer;
    reg       ped_shortened, next_ped_shortened;

    // State and timer logic synchronous process
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            timer <= 8'd0;
            ped_shortened <= 1'b0;
            red <= 1'b0;
            yellow <= 1'b0;
            green <= 1'b0;
            clock <= 8'd0;
        end else begin
            state <= next_state;
            timer <= next_timer;
            ped_shortened <= next_ped_shortened;
            clock <= next_timer;

            // Output signals updated synchronously to current state
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
                GREEN: begin
                    red <= 1'b0;
                    yellow <= 1'b0;
                    green <= 1'b1;
                end
                YELLOW: begin
                    red <= 1'b0;
                    yellow <= 1'b1;
                    green <= 1'b0;
                end
                default: begin
                    red <= 1'b0;
                    yellow <= 1'b0;
                    green <= 1'b0;
                end
            endcase
        end
    end

    // Next state, timer, and ped_shortened combinational logic
    always @(*) begin
        next_state = state;
        next_timer = timer;
        next_ped_shortened = ped_shortened;

        case(state)
            IDLE: begin
                next_state = RED;
                next_timer = RED_TIME;
                next_ped_shortened = 1'b0;
            end

            RED: begin
                if (timer == 0) begin
                    next_state = GREEN;
                    next_timer = GREEN_TIME;
                    next_ped_shortened = 1'b0;  // Reset ped_shortened on green entry
                end else begin
                    next_timer = timer - 1;
                    next_ped_shortened = ped_shortened;
                end
            end

            GREEN: begin
                // If pass_request is pressed and green time remaining > 10 and not already shortened, shorten it
                if (pass_request && !ped_shortened && (timer > GREEN_SHORT)) begin
                    next_timer = GREEN_SHORT;
                    next_ped_shortened = 1'b1;
                end else if (timer == 0) begin
                    next_state = YELLOW;
                    next_timer = YELLOW_TIME;
                    next_ped_shortened = 1'b0;
                end else begin
                    next_timer = timer - 1;
                    next_ped_shortened = ped_shortened;
                end
            end

            YELLOW: begin
                if (timer == 0) begin
                    next_state = RED;
                    next_timer = RED_TIME;
                    next_ped_shortened = 1'b0;
                end else begin
                    next_timer = timer - 1;
                    next_ped_shortened = ped_shortened;
                end
            end

            default: begin
                next_state = IDLE;
                next_timer = 8'd0;
                next_ped_shortened = 1'b0;
            end
        endcase
    end

endmodule