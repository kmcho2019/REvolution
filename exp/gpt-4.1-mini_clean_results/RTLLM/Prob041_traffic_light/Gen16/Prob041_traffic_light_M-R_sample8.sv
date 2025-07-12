module traffic_light (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       pass_request,
    output wire [7:0] clock,
    output wire       red,
    output wire       yellow,
    output wire       green
);

    // States encoding
    typedef enum logic [1:0] {
        IDLE   = 2'd0,
        RED    = 2'd1,
        YELLOW = 2'd2,
        GREEN  = 2'd3
    } state_t;

    localparam [7:0] RED_TIME    = 8'd10;
    localparam [7:0] YELLOW_TIME = 8'd5;
    localparam [7:0] GREEN_TIME  = 8'd60;
    localparam [7:0] SHORT_GREEN = 8'd10;

    state_t state, next_state;
    reg [7:0] cnt, next_cnt;

    // State transition: triggered when cnt == 0
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= RED;
        end else begin
            state <= next_state;
        end
    end

    // Counter update and state transition control
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= RED_TIME;
        end else begin
            cnt <= next_cnt;
        end
    end

    // Next state logic and counter update logic
    always @(*) begin
        next_state = state;
        next_cnt = cnt;

        if (cnt == 0) begin
            case(state)
                RED: begin
                    next_state = GREEN;
                    next_cnt = GREEN_TIME;
                end
                GREEN: begin
                    next_state = YELLOW;
                    next_cnt = YELLOW_TIME;
                end
                YELLOW: begin
                    next_state = RED;
                    next_cnt = RED_TIME;
                end
                default: begin
                    next_state = RED;
                    next_cnt = RED_TIME;
                end
            endcase
        end else begin
            // Pedestrian request handling: shorten green time if possible
            if ((state == GREEN) && pass_request && (cnt > SHORT_GREEN)) begin
                next_cnt = SHORT_GREEN;
            end else begin
                next_cnt = cnt - 1;
            end
        end
    end

    // Output logic as continuous assignments
    assign red    = (state == RED);
    assign yellow = (state == YELLOW);
    assign green  = (state == GREEN);
    assign clock  = cnt;

endmodule