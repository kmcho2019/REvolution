module traffic_light (
    input        rst_n,
    input        clk,
    input        pass_request,
    output reg [7:0] clock,
    output       red,
    output       yellow,
    output       green
);

    // State encoding
    localparam IDLE   = 2'd3; // Idle state for initialization
    localparam RED    = 2'd0;
    localparam GREEN  = 2'd1;
    localparam YELLOW = 2'd2;

    // Timing constants
    localparam RED_TIME     = 8'd10;
    localparam YELLOW_TIME  = 8'd5;
    localparam GREEN_TIME   = 8'd60;
    localparam GREEN_SHORT  = 8'd10;

    reg [1:0] state, next_state;
    reg [7:0] cnt, next_cnt;
    reg ped_shortened, next_ped_shortened;

    // Timer enable signal for decrementing only when timer > 0
    wire timer_en = (cnt != 0);

    // Synchronous state register with synchronous reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Synchronous counter register with synchronous reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt <= 8'd0;
        else
            cnt <= next_cnt;
    end

    // Pedestrian shortened flag register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            ped_shortened <= 1'b0;
        else
            ped_shortened <= next_ped_shortened;
    end

    // Next-state, counter, and ped_shortened combinational logic
    always @(*) begin
        // Default assignments to hold current values
        next_state = state;
        next_cnt = cnt;
        next_ped_shortened = ped_shortened;

        case (state)
            IDLE: begin
                // Initialize outputs and counter, then transition to RED immediately
                next_state = RED;
                next_cnt = RED_TIME;
                next_ped_shortened = 1'b0;
            end

            RED: begin
                // Clear pedestrian shortened flag entering RED
                next_ped_shortened = 1'b0;
                if (cnt == 0) begin
                    next_state = GREEN;
                    next_cnt = GREEN_TIME;
                    next_ped_shortened = 1'b0;
                end else if (timer_en) begin
                    next_cnt = cnt - 1;
                end
            end

            GREEN: begin
                // Apply pedestrian shortening once if requested and timer > 10
                if (pass_request && !ped_shortened && (cnt > GREEN_SHORT)) begin
                    next_cnt = GREEN_SHORT;
                    next_ped_shortened = 1'b1;
                end else if (cnt == 0) begin
                    next_state = YELLOW;
                    next_cnt = YELLOW_TIME;
                    next_ped_shortened = 1'b0;
                end else if (timer_en) begin
                    next_cnt = cnt - 1;
                end
            end

            YELLOW: begin
                // Clear pedestrian shortened flag entering YELLOW
                next_ped_shortened = 1'b0;
                if (cnt == 0) begin
                    next_state = RED;
                    next_cnt = RED_TIME;
                end else if (timer_en) begin
                    next_cnt = cnt - 1;
                end
            end

            default: begin
                // Failsafe: reset to IDLE
                next_state = IDLE;
                next_cnt = 8'd0;
                next_ped_shortened = 1'b0;
            end
        endcase
    end

    // Output signals combinationally assigned from state
    assign red    = (state == RED);
    assign yellow = (state == YELLOW);
    assign green  = (state == GREEN);

    // Output the current timer value
    always @(*) begin
        clock = cnt;
    end

endmodule