module traffic_light (
    input        rst_n,
    input        clk,
    input        pass_request,
    output reg [7:0] clock,
    output       red,
    output       yellow,
    output       green
);

    // Timing parameters (7 bits)
    localparam RED_TIME     = 7'd10;
    localparam YELLOW_TIME  = 7'd5;
    localparam GREEN_TIME   = 7'd60;
    localparam GREEN_SHORT  = 7'd10;

    // One-hot state encoding for clarity and potential area/timing benefit
    localparam IDLE   = 3'b000; // Not used after initial reset, included for completeness
    localparam RED    = 3'b001;
    localparam GREEN  = 3'b010;
    localparam YELLOW = 3'b100;

    reg [2:0] state, next_state;

    // 7-bit counter
    reg [6:0] cnt, next_cnt;

    // ped_shortened flag to prevent multiple green shortenings per green phase
    reg ped_shortened, next_ped_shortened;

    // State register with synchronous active-low reset
    always @(posedge clk) begin
        if (!rst_n)
            state <= RED;
        else
            state <= next_state;
    end

    // Counter register with synchronous reset, only update when needed to reduce toggling
    always @(posedge clk) begin
        if (!rst_n)
            cnt <= RED_TIME;
        else if (cnt != next_cnt)
            cnt <= next_cnt;
    end

    // ped_shortened register, updated only on change
    always @(posedge clk) begin
        if (!rst_n)
            ped_shortened <= 1'b0;
        else if (ped_shortened != next_ped_shortened)
            ped_shortened <= next_ped_shortened;
    end

    // Next state logic
    always @(*) begin
        // Defaults
        next_state = state;
        next_cnt = cnt;
        next_ped_shortened = ped_shortened;

        case (state)
            RED: begin
                // Clear ped_shortened on RED state
                if (ped_shortened)
                    next_ped_shortened = 1'b0;

                if (cnt == 0) begin
                    next_state = GREEN;
                    next_cnt = GREEN_TIME;
                    next_ped_shortened = 1'b0; // Clear when entering GREEN
                end
                else begin
                    next_cnt = cnt - 1;
                end
            end

            GREEN: begin
                // Shorten green on pass_request if not already shortened and cnt > 10
                if (pass_request && !ped_shortened && (cnt > GREEN_SHORT)) begin
                    next_cnt = GREEN_SHORT;
                    next_ped_shortened = 1'b1;
                end
                else if (cnt == 0) begin
                    next_state = YELLOW;
                    next_cnt = YELLOW_TIME;
                    next_ped_shortened = 1'b0; // Reset leaving GREEN
                end
                else begin
                    next_cnt = cnt - 1;
                end
            end

            YELLOW: begin
                // Clear ped_shortened on YELLOW state
                if (ped_shortened)
                    next_ped_shortened = 1'b0;

                if (cnt == 0) begin
                    next_state = RED;
                    next_cnt = RED_TIME;
                end
                else begin
                    next_cnt = cnt - 1;
                end
            end

            default: begin
                next_state = RED;
                next_cnt = RED_TIME;
                next_ped_shortened = 1'b0;
            end
        endcase
    end

    // Outputs combinationally driven from state
    assign red    = (state == RED);
    assign yellow = (state == YELLOW);
    assign green  = (state == GREEN);

    // Output clock is 8-bit, pad MSB zero for compatibility with interface
    always @(*) begin
        clock = {1'b0, cnt};
    end

endmodule