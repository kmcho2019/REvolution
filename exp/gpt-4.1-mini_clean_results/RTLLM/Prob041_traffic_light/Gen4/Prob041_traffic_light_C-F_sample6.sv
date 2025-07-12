module traffic_light (
    input        rst_n,
    input        clk,
    input        pass_request,
    output [7:0] clock,
    output reg   red,
    output reg   yellow,
    output reg   green
);

    // Timing parameters
    localparam RED_TIME    = 8'd10;
    localparam YELLOW_TIME = 8'd5;
    localparam GREEN_TIME  = 8'd60;
    localparam GREEN_SHORT = 8'd10;

    typedef enum reg [1:0] {
        RED    = 2'd0,
        GREEN  = 2'd1,
        YELLOW = 2'd2
    } state_t;

    state_t state, next_state;
    reg [7:0] cnt, next_cnt;

    // Sequential logic for state and counter
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= RED;
            cnt <= RED_TIME;
        end else begin
            state <= next_state;
            cnt <= next_cnt;
        end
    end

    // Combinational logic for next state and counter
    always @(*) begin
        // Default assignments
        next_state = state;
        next_cnt = cnt;

        case(state)
            RED: begin
                if (cnt == 0) begin
                    next_state = GREEN;
                    next_cnt = GREEN_TIME;
                end else begin
                    next_cnt = cnt - 1;
                end
            end

            GREEN: begin
                if (cnt == 0) begin
                    next_state = YELLOW;
                    next_cnt = YELLOW_TIME;
                end else if (pass_request && (cnt > GREEN_SHORT)) begin
                    // Shorten green time to GREEN_SHORT if request and remaining time > GREEN_SHORT
                    next_cnt = GREEN_SHORT;
                end else begin
                    next_cnt = cnt - 1;
                end
            end

            YELLOW: begin
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
            end
        endcase
    end

    // Output logic synchronized with clock (registered outputs)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            red    <= 1'b0;
            yellow <= 1'b0;
            green  <= 1'b0;
        end else begin
            red    <= (state == RED);
            yellow <= (state == YELLOW);
            green  <= (state == GREEN);
        end
    end

    // Assign internal counter to output
    assign clock = cnt;

endmodule