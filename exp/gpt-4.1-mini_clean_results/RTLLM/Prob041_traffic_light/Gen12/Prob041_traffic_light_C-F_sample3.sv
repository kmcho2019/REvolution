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

    // State encoding
    localparam RED    = 2'd0;
    localparam GREEN  = 2'd1;
    localparam YELLOW = 2'd2;

    reg [1:0] state, next_state;
    reg [6:0] cnt, next_cnt;
    reg ped_shortened, next_ped_shortened;

    // Timer enable: decrement only if timer > 0
    wire timer_en = (cnt != 0);

    // State register with synchronous reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= RED;
        else
            state <= next_state;
    end

    // Counter register with synchronous reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt <= RED_TIME;
        else
            cnt <= next_cnt;
    end

    // ped_shortened flag register with synchronous reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            ped_shortened <= 1'b0;
        else
            ped_shortened <= next_ped_shortened;
    end

    // Next state, counter, and ped_shortened logic
    always @(*) begin
        // Default assignments: hold current state and counter; no ped_shortened change
        next_state = state;
        next_cnt = cnt;
        next_ped_shortened = ped_shortened;

        case (state)
            RED: begin
                // Reset ped_shortened on RED entry
                next_ped_shortened = 1'b0;
                if (cnt == 0) begin
                    next_state = GREEN;
                    next_cnt = GREEN_TIME;
                    // Reset ped_shortened on GREEN entry
                    next_ped_shortened = 1'b0;
                end
                else if (timer_en)
                    next_cnt = cnt - 1;
            end

            GREEN: begin
                // Pedestrian request shortens green only once and only if remaining time > 10
                if (pass_request && !ped_shortened && (cnt > GREEN_SHORT)) begin
                    next_cnt = GREEN_SHORT;
                    next_ped_shortened = 1'b1;
                end
                else if (cnt == 0) begin
                    next_state = YELLOW;
                    next_cnt = YELLOW_TIME;
                    next_ped_shortened = 1'b0; // Reset on leaving GREEN
                end
                else if (timer_en)
                    next_cnt = cnt - 1;
            end

            YELLOW: begin
                // Reset ped_shortened on YELLOW entry
                next_ped_shortened = 1'b0;
                if (cnt == 0) begin
                    next_state = RED;
                    next_cnt = RED_TIME;
                end
                else if (timer_en)
                    next_cnt = cnt - 1;
            end

            default: begin
                next_state = RED;
                next_cnt = RED_TIME;
                next_ped_shortened = 1'b0;
            end
        endcase
    end

    // Outputs combinationally derived from current state
    assign red    = (state == RED);
    assign yellow = (state == YELLOW);
    assign green  = (state == GREEN);

    // Assign clock output from counter register (7-bit)
    always @(*) begin
        clock = cnt;
    end

endmodule