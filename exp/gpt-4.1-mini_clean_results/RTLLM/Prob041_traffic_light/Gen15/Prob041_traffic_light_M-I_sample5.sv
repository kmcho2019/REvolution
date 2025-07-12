module traffic_light (
    input        rst_n,
    input        clk,
    input        pass_request,
    output wire [7:0] clock,
    output       red,
    output       yellow,
    output       green
);

    // Timing parameters (all fit in 6 bits)
    localparam [5:0] RED_TIME     = 6'd10;
    localparam [5:0] YELLOW_TIME  = 6'd5;
    localparam [5:0] GREEN_TIME   = 6'd60;
    localparam [5:0] GREEN_SHORT  = 6'd10;

    // State encoding
    localparam [1:0] IDLE   = 2'd0;
    localparam [1:0] S1_RED = 2'd1;
    localparam [1:0] S2_YELLOW = 2'd2;
    localparam [1:0] S3_GREEN = 2'd3;

    reg [1:0] state, next_state;
    reg [5:0] cnt, next_cnt;
    reg ped_shortened, next_ped_shortened;

    // Next state logic
    always @(*) begin
        next_state = state;
        if (cnt == 0) begin
            case (state)
                IDLE:       next_state = S1_RED;
                S1_RED:     next_state = S3_GREEN;
                S3_GREEN:   next_state = S2_YELLOW;
                S2_YELLOW:  next_state = S1_RED;
                default:    next_state = S1_RED;
            endcase
        end
    end

    // Next ped_shortened logic
    always @(*) begin
        next_ped_shortened = ped_shortened;
        if (state != S3_GREEN)
            next_ped_shortened = 1'b0; // reset when leaving green
        else if (pass_request && !ped_shortened && (cnt > GREEN_SHORT))
            next_ped_shortened = 1'b1; // set once per green cycle when shortening
    end

    // Next counter logic
    always @(*) begin
        // Default decrement by 1 if not zero
        if (cnt != 0)
            next_cnt = cnt - 1;
        else begin
            // Load timer based on next state after current state completes
            case (next_state)
                S1_RED:    next_cnt = RED_TIME;
                S3_GREEN:  next_cnt = GREEN_TIME;
                S2_YELLOW: next_cnt = YELLOW_TIME;
                default:   next_cnt = RED_TIME;
            endcase
        end

        // If in green state and pedestrian request shortens time and not shortened yet
        if ((state == S3_GREEN) && pass_request && !ped_shortened && (cnt > GREEN_SHORT))
            next_cnt = GREEN_SHORT;
    end

    // Sequential logic for state, cnt, ped_shortened
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            cnt <= RED_TIME;
            ped_shortened <= 1'b0;
        end else begin
            state <= next_state;
            cnt <= next_cnt;
            ped_shortened <= next_ped_shortened;
        end
    end

    // Output signals derived from state
    assign red    = (state == S1_RED);
    assign yellow = (state == S2_YELLOW);
    assign green  = (state == S3_GREEN);

    // Output clock as 8-bit zero-extended counter value
    assign clock = {2'b00, cnt};

endmodule