module traffic_light (
    input        rst_n,
    input        clk,
    input        pass_request,
    output reg [6:0] clock,
    output       red,
    output       yellow,
    output       green
);

    // Timing parameters
    localparam RED_TIME     = 7'd10;
    localparam YELLOW_TIME  = 7'd5;
    localparam GREEN_TIME   = 7'd60;
    localparam GREEN_SHORT  = 7'd10;

    // States
    localparam RED    = 2'd0;
    localparam GREEN  = 2'd1;
    localparam YELLOW = 2'd2;

    reg [1:0] state, next_state;
    reg [6:0] cnt, next_cnt;
    reg ped_shortened, next_ped_shortened;

    // State transition combinational logic
    always @(*) begin
        next_state = state;
        if (cnt == 0) begin
            case (state)
                RED:    next_state = GREEN;
                GREEN:  next_state = YELLOW;
                YELLOW: next_state = RED;
                default: next_state = RED;
            endcase
        end
    end

    // Counter update combinational logic
    always @(*) begin
        next_cnt = cnt;
        case (state)
            RED: begin
                if (cnt == 0)
                    next_cnt = GREEN_TIME;
                else
                    next_cnt = cnt - 1;
            end
            GREEN: begin
                if (cnt == 0)
                    next_cnt = YELLOW_TIME;
                else if (pass_request && !ped_shortened && (cnt > GREEN_SHORT))
                    next_cnt = GREEN_SHORT;
                else
                    next_cnt = cnt - 1;
            end
            YELLOW: begin
                if (cnt == 0)
                    next_cnt = RED_TIME;
                else
                    next_cnt = cnt - 1;
            end
            default: next_cnt = RED_TIME;
        endcase
    end

    // ped_shortened flag combinational logic
    always @(*) begin
        next_ped_shortened = ped_shortened;
        if (state != GREEN)
            next_ped_shortened = 1'b0; // reset on leaving GREEN
        else if (pass_request && !ped_shortened && (cnt > GREEN_SHORT))
            next_ped_shortened = 1'b1; // set when shortening green time
    end

    // Synchronous logic for state, counter, and ped_shortened
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= RED;
            cnt <= RED_TIME;
            ped_shortened <= 1'b0;
        end else begin
            state <= next_state;
            cnt <= next_cnt;
            ped_shortened <= next_ped_shortened;
        end
    end

    // Output assignments derived from state
    assign red    = (state == RED);
    assign yellow = (state == YELLOW);
    assign green  = (state == GREEN);

    // Assign internal counter to output clock
    always @(*) begin
        clock = cnt;
    end

endmodule