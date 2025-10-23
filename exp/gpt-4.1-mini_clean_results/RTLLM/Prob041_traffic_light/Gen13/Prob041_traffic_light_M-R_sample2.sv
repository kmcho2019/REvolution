module traffic_light (
    input  wire       rst_n,
    input  wire       clk,
    input  wire       pass_request,
    output wire [7:0] clock,
    output wire       red,
    output wire       yellow,
    output wire       green
);

    // State encoding
    localparam IDLE    = 2'd0;
    localparam RED     = 2'd1;
    localparam YELLOW  = 2'd2;
    localparam GREEN   = 2'd3;

    localparam RED_TIME    = 8'd10;
    localparam YELLOW_TIME = 8'd5;
    localparam GREEN_TIME  = 8'd60;
    localparam SHORT_GREEN = 8'd10;

    reg [1:0] state, next_state;
    reg [7:0] cnt, next_cnt;

    // Sequential state and counter update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= RED;
            cnt <= RED_TIME;
        end else begin
            state <= next_state;
            cnt <= next_cnt;
        end
    end

    // Combinational next state and next counter logic
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
                if (pass_request && (cnt > SHORT_GREEN)) begin
                    next_cnt = SHORT_GREEN;
                    next_state = GREEN;
                end else if (cnt == 0) begin
                    next_state = YELLOW;
                    next_cnt = YELLOW_TIME;
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

    // Output logic by state
    assign red    = (state == RED);
    assign yellow = (state == YELLOW);
    assign green  = (state == GREEN);
    assign clock  = cnt;

endmodule