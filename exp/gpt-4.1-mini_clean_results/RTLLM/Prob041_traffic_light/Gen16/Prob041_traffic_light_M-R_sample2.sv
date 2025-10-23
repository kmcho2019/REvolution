module traffic_light (
    input        rst_n,
    input        clk,
    input        pass_request,
    output [7:0] clock,
    output       red,
    output       yellow,
    output       green
);

    // Timing parameters
    localparam RED_TIME    = 8'd10;
    localparam YELLOW_TIME = 8'd5;
    localparam GREEN_TIME  = 8'd60;
    localparam GREEN_SHORT = 8'd10;

    // State encoding
    typedef enum logic [1:0] {
        RED    = 2'd0,
        GREEN  = 2'd1,
        YELLOW = 2'd2
    } state_t;

    state_t state, next_state;
    reg [7:0] cnt, next_cnt;
    reg ped_shortened, next_ped_shortened;

    // State and counter update on clock edge
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state         <= RED;
            cnt           <= RED_TIME;
            ped_shortened <= 1'b0;
        end else begin
            state         <= next_state;
            cnt           <= next_cnt;
            ped_shortened <= next_ped_shortened;
        end
    end

    // Next-state and counter logic (Mealy FSM)
    always @(*) begin
        // Default assignments: hold current values
        next_state         = state;
        next_cnt           = cnt;
        next_ped_shortened = ped_shortened;

        case (state)
            RED: begin
                next_ped_shortened = 1'b0;  // Reset shortening flag in RED
                if (cnt == 0) begin
                    next_state = GREEN;
                    next_cnt = GREEN_TIME;
                    next_ped_shortened = 1'b0;
                end else begin
                    next_cnt = cnt - 1;
                end
            end

            GREEN: begin
                // If pedestrian pressed and green time > 10 and not shortened yet
                if (pass_request && !ped_shortened && (cnt > GREEN_SHORT)) begin
                    next_cnt = GREEN_SHORT;
                    next_ped_shortened = 1'b1;
                end else if (cnt == 0) begin
                    next_state = YELLOW;
                    next_cnt = YELLOW_TIME;
                    next_ped_shortened = 1'b0;
                end else begin
                    next_cnt = cnt - 1;
                end
            end

            YELLOW: begin
                next_ped_shortened = 1'b0;
                if (cnt == 0) begin
                    next_state = RED;
                    next_cnt = RED_TIME;
                end else begin
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

    // Outputs combinationally from current state
    assign red    = (state == RED);
    assign yellow = (state == YELLOW);
    assign green  = (state == GREEN);

    // Output current counter value (8 bits)
    assign clock = cnt;

endmodule