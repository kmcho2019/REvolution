module traffic_light (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       pass_request,
    output reg  [7:0] clock,
    output wire       red,
    output wire       yellow,
    output wire       green
);

    // State encoding
    localparam IDLE     = 2'd0;
    localparam S1_RED   = 2'd1;
    localparam S2_YELLOW= 2'd2;
    localparam S3_GREEN = 2'd3;

    // Timing constants
    localparam RED_TIME    = 8'd10;
    localparam YELLOW_TIME = 8'd5;
    localparam GREEN_TIME  = 8'd60;
    localparam SHORT_GREEN = 8'd10;

    reg [1:0] state, next_state;
    reg [7:0] cnt, next_cnt;

    // Pedestrian shortening apply flag to ensure shortening happens only once per green phase
    reg ped_shortened, next_ped_shortened;

    // Timer enable: only decrement if timer not zero
    wire timer_en = (cnt != 0);

    // Synchronous process: state, counter and ped_shortened updates
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state         <= IDLE;
            cnt           <= 8'd0;
            ped_shortened <= 1'b0;
        end else begin
            state         <= next_state;
            cnt           <= next_cnt;
            ped_shortened <= next_ped_shortened;
        end
    end

    // Next state, counter and ped_shortened logic
    always @(*) begin
        next_state = state;
        next_cnt = cnt;
        next_ped_shortened = ped_shortened;

        case (state)
            IDLE: begin
                // Immediately transition to RED state and initialize counter
                next_state = S1_RED;
                next_cnt = RED_TIME;
                next_ped_shortened = 1'b0;
            end

            S1_RED: begin
                next_ped_shortened = 1'b0; // Reset pedestrian shortened flag on non-green states
                if (cnt == 0) begin
                    next_state = S3_GREEN;
                    next_cnt = GREEN_TIME;
                    next_ped_shortened = 1'b0;
                end else if (timer_en) begin
                    next_cnt = cnt - 1;
                end
            end

            S3_GREEN: begin
                // Handle pedestrian request shortening logic:
                // If pass_request asserted, green timer remaining > SHORT_GREEN, and shortening not yet applied,
                // then shorten timer to SHORT_GREEN immediately.
                if (pass_request && (cnt > SHORT_GREEN) && !ped_shortened) begin
                    next_cnt = SHORT_GREEN;
                    next_ped_shortened = 1'b1;
                end else if (cnt == 0) begin
                    next_state = S2_YELLOW;
                    next_cnt = YELLOW_TIME;
                    next_ped_shortened = 1'b0;
                end else if (timer_en) begin
                    next_cnt = cnt - 1;
                end
            end

            S2_YELLOW: begin
                next_ped_shortened = 1'b0; // Reset pedestrian shortened flag on non-green states
                if (cnt == 0) begin
                    next_state = S1_RED;
                    next_cnt = RED_TIME;
                end else if (timer_en) begin
                    next_cnt = cnt - 1;
                end
            end

            default: begin
                // Safety fallback: reset to IDLE
                next_state = IDLE;
                next_cnt = 8'd0;
                next_ped_shortened = 1'b0;
            end
        endcase
    end

    // Output lights assigned combinationally from state
    assign red    = (state == S1_RED);
    assign yellow = (state == S2_YELLOW);
    assign green  = (state == S3_GREEN);

    // Output current timer value
    always @(*) begin
        clock = cnt;
    end

endmodule