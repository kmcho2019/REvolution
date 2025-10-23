module traffic_light (
    input        rst_n,
    input        clk,
    input        pass_request,
    output reg [6:0] clock,
    output       red,
    output       yellow,
    output       green
);

    // Timing parameters (7 bits)
    localparam RED_TIME     = 7'd10;
    localparam YELLOW_TIME  = 7'd5;
    localparam GREEN_TIME   = 7'd60;
    localparam GREEN_SHORT  = 7'd10;

    // One-hot state encoding for better timing and simpler logic
    localparam [2:0] RED_STATE    = 3'b001;
    localparam [2:0] GREEN_STATE  = 3'b010;
    localparam [2:0] YELLOW_STATE = 3'b100;

    reg [2:0] state, next_state;
    reg [6:0] cnt, next_cnt;
    reg ped_shortened, next_ped_shortened;

    wire timer_en = (cnt != 0);

    // Synchronous reset and state update
    always @(posedge clk) begin
        if (!rst_n) begin
            state <= RED_STATE;
            cnt <= RED_TIME;
            ped_shortened <= 1'b0;
        end else begin
            state <= next_state;
            cnt <= next_cnt;
            ped_shortened <= next_ped_shortened;
        end
    end

    // Next state logic, counter, and ped_shortened control
    always @(*) begin
        next_state = state;
        next_cnt = cnt;
        next_ped_shortened = ped_shortened;

        case (state)
            RED_STATE: begin
                if (cnt == 0) begin
                    next_state = GREEN_STATE;
                    next_cnt = GREEN_TIME;
                    next_ped_shortened = 1'b0; // reset flag entering green
                end else if (timer_en) begin
                    next_cnt = cnt - 1;
                end
            end

            GREEN_STATE: begin
                // Apply pedestrian request shortening once and only if cnt > 10
                if (pass_request && !ped_shortened && (cnt > GREEN_SHORT)) begin
                    next_cnt = GREEN_SHORT;
                    next_ped_shortened = 1'b1;
                end else if (cnt == 0) begin
                    next_state = YELLOW_STATE;
                    next_cnt = YELLOW_TIME;
                    next_ped_shortened = 1'b0; // reset flag leaving green
                end else if (timer_en) begin
                    next_cnt = cnt - 1;
                end
            end

            YELLOW_STATE: begin
                if (cnt == 0) begin
                    next_state = RED_STATE;
                    next_cnt = RED_TIME;
                    next_ped_shortened = 1'b0; // reset flag entering red
                end else if (timer_en) begin
                    next_cnt = cnt - 1;
                end
            end

            default: begin
                next_state = RED_STATE;
                next_cnt = RED_TIME;
                next_ped_shortened = 1'b0;
            end
        endcase
    end

    // Registered output clock to avoid glitches
    always @(posedge clk) begin
        if (!rst_n)
            clock <= RED_TIME;
        else
            clock <= cnt;
    end

    // Outputs derived combinationally from current state
    assign red    = (state == RED_STATE);
    assign yellow = (state == YELLOW_STATE);
    assign green  = (state == GREEN_STATE);

endmodule