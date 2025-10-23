module traffic_light (
    input         rst_n,        // async active-low reset
    input         clk,
    input         pass_request,
    output [7:0]  clock,        // 8-bit output as requested (pad with 0 msb)
    output        red,
    output        yellow,
    output        green
);

    // Parameters and localparams for timings and states
    localparam CNT_WIDTH   = 7;
    localparam RED_TIME    = 7'd10;
    localparam YELLOW_TIME = 7'd5;
    localparam GREEN_TIME  = 7'd60;
    localparam GREEN_SHORT = 7'd10;

    localparam [1:0]
        S_RED    = 2'd0,
        S_GREEN  = 2'd1,
        S_YELLOW = 2'd2;

    // Internal signals
    reg  [1:0]  state, next_state;
    reg  [CNT_WIDTH-1:0] cnt, next_cnt;
    reg  ped_shortened, next_ped_shortened;

    // Synchronize async reset (double flop)
    reg rst_n_sync_0, rst_n_sync_1;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rst_n_sync_0 <= 1'b0;
            rst_n_sync_1 <= 1'b0;
        end else begin
            rst_n_sync_0 <= 1'b1;
            rst_n_sync_1 <= rst_n_sync_0;
        end
    end
    wire rst_sync = rst_n_sync_1;

    // State register and ped_shortened flag with synchronous reset
    always @(posedge clk) begin
        if (!rst_sync) begin
            state <= S_RED;
            ped_shortened <= 1'b0;
        end else begin
            state <= next_state;
            ped_shortened <= next_ped_shortened;
        end
    end

    // Counter register with synchronous reset
    always @(posedge clk) begin
        if (!rst_sync)
            cnt <= RED_TIME;
        else
            cnt <= next_cnt;
    end

    // Next state and counter logic
    always @(*) begin
        // Defaults: hold current state and counter, ped_shortened unchanged
        next_state = state;
        next_cnt = cnt;
        next_ped_shortened = ped_shortened;

        // Enable counting only if cnt > 0
        wire cnt_nonzero = (cnt != 0);

        case(state)
            S_RED: begin
                // Clear ped_shortened in RED state
                next_ped_shortened = 1'b0;
                if (cnt == 0) begin
                    next_state = S_GREEN;
                    next_cnt = GREEN_TIME;
                    next_ped_shortened = 1'b0;
                end else if (cnt_nonzero) begin
                    next_cnt = cnt - 1;
                end
            end

            S_GREEN: begin
                // Shorten green phase if request and not already shortened
                if (pass_request && !ped_shortened && (cnt > GREEN_SHORT)) begin
                    next_cnt = GREEN_SHORT;
                    next_ped_shortened = 1'b1;
                end else if (cnt == 0) begin
                    next_state = S_YELLOW;
                    next_cnt = YELLOW_TIME;
                    next_ped_shortened = 1'b0;
                end else if (cnt_nonzero) begin
                    next_cnt = cnt - 1;
                end
            end

            S_YELLOW: begin
                // Clear ped_shortened in YELLOW state
                next_ped_shortened = 1'b0;
                if (cnt == 0) begin
                    next_state = S_RED;
                    next_cnt = RED_TIME;
                end else if (cnt_nonzero) begin
                    next_cnt = cnt - 1;
                end
            end

            default: begin
                next_state = S_RED;
                next_cnt = RED_TIME;
                next_ped_shortened = 1'b0;
            end
        endcase
    end

    // Output assignment combinationally from state
    assign red    = (state == S_RED);
    assign yellow = (state == S_YELLOW);
    assign green  = (state == S_GREEN);

    // Output clock is 8-bit with MSB zero-padded
    assign clock = {1'b0, cnt};

endmodule