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

    // One-hot state encoding for better timing
    localparam S_RED    = 3'b001;
    localparam S_GREEN  = 3'b010;
    localparam S_YELLOW = 3'b100;

    reg [2:0] state, next_state;
    reg [7:0] cnt, next_cnt;

    // Control signal: enable counting or reload
    reg cnt_en;

    // Next state and next counter logic combinational block
    always @(*) begin
        next_state = state;
        next_cnt   = cnt;
        cnt_en     = 1'b0;

        case (state)
            S_RED: begin
                if (cnt == 0) begin
                    next_state = S_GREEN;
                    next_cnt   = GREEN_TIME;
                    cnt_en     = 1'b1; // start counting down green
                end else begin
                    cnt_en   = 1'b1; // keep counting down red
                    next_cnt = cnt - 1;
                end
            end
            S_GREEN: begin
                if (cnt == 0) begin
                    next_state = S_YELLOW;
                    next_cnt   = YELLOW_TIME;
                    cnt_en     = 1'b1;
                end else if (pass_request && (cnt > GREEN_SHORT)) begin
                    // shorten green time to GREEN_SHORT on pedestrian request
                    next_cnt = GREEN_SHORT;
                    cnt_en   = 1'b1;
                end else begin
                    cnt_en   = 1'b1;
                    next_cnt = cnt - 1;
                end
            end
            S_YELLOW: begin
                if (cnt == 0) begin
                    next_state = S_RED;
                    next_cnt   = RED_TIME;
                    cnt_en     = 1'b1;
                end else begin
                    cnt_en   = 1'b1;
                    next_cnt = cnt - 1;
                end
            end
            default: begin
                next_state = S_RED;
                next_cnt   = RED_TIME;
                cnt_en     = 1'b1;
            end
        endcase
    end

    // State and counter registers synchronous with reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= S_RED;
            cnt   <= RED_TIME;
        end else begin
            state <= next_state;
            if (cnt_en)
                cnt <= next_cnt;
            else
                cnt <= cnt; // hold value, no toggle
        end
    end

    // Outputs directly from one-hot state bits
    assign red    = (state == S_RED);
    assign green  = (state == S_GREEN);
    assign yellow = (state == S_YELLOW);

    assign clock = cnt;

endmodule