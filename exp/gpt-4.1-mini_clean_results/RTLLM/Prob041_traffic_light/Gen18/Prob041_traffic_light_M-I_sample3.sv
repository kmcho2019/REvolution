module traffic_light (
    input             rst_n,
    input             clk,
    input             pass_request,
    output reg [5:0]  clock,
    output            red,
    output            yellow,
    output            green
);

    // Timing parameters (6 bits)
    localparam RED_TIME     = 6'd10;
    localparam YELLOW_TIME  = 6'd5;
    localparam GREEN_TIME   = 6'd60;
    localparam GREEN_SHORT  = 6'd10;

    // State encoding
    localparam RED    = 2'd0;
    localparam GREEN  = 2'd1;
    localparam YELLOW = 2'd2;

    reg [1:0]  state, next_state;
    reg [5:0]  cnt, next_cnt;
    reg        ped_shortened, next_ped_shortened;

    wire timer_en = (cnt != 0);

    // State register (synchronous reset)
    always @(posedge clk) begin
        if (!rst_n)
            state <= RED;
        else
            state <= next_state;
    end

    // Counter register (synchronous reset)
    always @(posedge clk) begin
        if (!rst_n)
            cnt <= RED_TIME;
        else
            cnt <= next_cnt;
    end

    // Pedestrian shortened flag register (synchronous reset)
    always @(posedge clk) begin
        if (!rst_n)
            ped_shortened <= 1'b0;
        else
            ped_shortened <= next_ped_shortened;
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            RED: begin
                if (cnt == 0)
                    next_state = GREEN;
            end
            GREEN: begin
                if (cnt == 0)
                    next_state = YELLOW;
            end
            YELLOW: begin
                if (cnt == 0)
                    next_state = RED;
            end
            default: next_state = RED;
        endcase
    end

    // Next counter logic
    always @(*) begin
        next_cnt = cnt;
        case (state)
            RED: begin
                if (cnt == 0)
                    next_cnt = GREEN_TIME;
                else if (timer_en)
                    next_cnt = cnt - 1;
            end
            GREEN: begin
                if (pass_request && !ped_shortened && (cnt > GREEN_SHORT))
                    next_cnt = GREEN_SHORT;
                else if (cnt == 0)
                    next_cnt = YELLOW_TIME;
                else if (timer_en)
                    next_cnt = cnt - 1;
            end
            YELLOW: begin
                if (cnt == 0)
                    next_cnt = RED_TIME;
                else if (timer_en)
                    next_cnt = cnt - 1;
            end
            default: next_cnt = RED_TIME;
        endcase
    end

    // Next ped_shortened logic: reset at GREEN entry and YELLOW entry, set only once during GREEN when pass_request shortening happens
    always @(*) begin
        next_ped_shortened = ped_shortened;
        if (!rst_n)
            next_ped_shortened = 1'b0;
        else begin
            case (state)
                RED: next_ped_shortened = 1'b0;
                GREEN: begin
                    if (pass_request && !ped_shortened && (cnt > GREEN_SHORT))
                        next_ped_shortened = 1'b1;
                end
                YELLOW: next_ped_shortened = 1'b0;
            endcase
        end
    end

    // Outputs assigned directly from state for minimal logic
    assign red    = (state == RED);
    assign yellow = (state == YELLOW);
    assign green  = (state == GREEN);

    // Registered clock output synchronized with counter
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clock <= RED_TIME;
        else
            clock <= cnt;
    end

endmodule