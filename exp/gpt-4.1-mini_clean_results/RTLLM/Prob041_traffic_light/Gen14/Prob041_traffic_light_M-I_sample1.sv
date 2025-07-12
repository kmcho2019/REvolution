module traffic_light (
    input        rst_n,
    input        clk,
    input        pass_request,
    output [6:0] clock,
    output       red,
    output       yellow,
    output       green
);

    // Timing parameters
    localparam RED_TIME     = 7'd10;
    localparam YELLOW_TIME  = 7'd5;
    localparam GREEN_TIME   = 7'd60;
    localparam GREEN_SHORT  = 7'd10;

    // State encoding
    localparam RED_STATE    = 2'd0;
    localparam GREEN_STATE  = 2'd1;
    localparam YELLOW_STATE = 2'd2;

    reg [1:0] state, next_state;
    reg [6:0] cnt, next_cnt;
    reg ped_shortened, next_ped_shortened;

    // Next state logic: advance when counter reaches zero
    always @(*) begin
        case (state)
            RED_STATE: 
                next_state = (cnt == 0) ? GREEN_STATE : RED_STATE;
            GREEN_STATE:
                next_state = (cnt == 0) ? YELLOW_STATE : GREEN_STATE;
            YELLOW_STATE:
                next_state = (cnt == 0) ? RED_STATE : YELLOW_STATE;
            default:
                next_state = RED_STATE;
        endcase
    end

    // Next counter logic
    always @(*) begin
        next_cnt = cnt;
        case (state)
            RED_STATE: begin
                if (cnt == 0)
                    next_cnt = GREEN_TIME;
                else
                    next_cnt = cnt - 1;
            end

            GREEN_STATE: begin
                if (cnt == 0) 
                    next_cnt = YELLOW_TIME;
                else if (pass_request && !ped_shortened && (cnt > GREEN_SHORT))
                    next_cnt = GREEN_SHORT;
                else
                    next_cnt = cnt - 1;
            end

            YELLOW_STATE: begin
                if (cnt == 0)
                    next_cnt = RED_TIME;
                else
                    next_cnt = cnt - 1;
            end

            default: next_cnt = RED_TIME;
        endcase
    end

    // ped_shortened logic: resets on green entry; set when pass_request shortens green
    always @(*) begin
        if (state != GREEN_STATE)
            next_ped_shortened = 1'b0;
        else if (pass_request && !ped_shortened && (cnt > GREEN_SHORT))
            next_ped_shortened = 1'b1;
        else
            next_ped_shortened = ped_shortened;
    end

    // Sequential logic: state, counter, ped_shortened update
    always @(posedge clk or negedge rst_n) begin
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

    // Output assignments derived from state
    assign red    = (state == RED_STATE);
    assign yellow = (state == YELLOW_STATE);
    assign green  = (state == GREEN_STATE);

    // Directly assign internal counter to output clock to avoid unnecessary registers
    assign clock = cnt;

endmodule