module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state, next_state;

    reg [1:0] cycle_cnt, next_cycle_cnt;    // 2-bit cycle counter (0 to 2)
    reg [1:0] w_accum, next_w_accum;        // 2-bit accumulator for w count (max 3)

    reg next_z;

    wire cnt_enable = (state == B);

    always @(*) begin
        // Defaults
        next_state = state;
        next_cycle_cnt = cycle_cnt;
        next_w_accum = w_accum;
        next_z = 1'b0;

        case(state)
            A: begin
                next_z = 1'b0;
                next_cycle_cnt = 2'd0;
                next_w_accum = 2'd0;
                if (s)
                    next_state = B;
                else
                    next_state = A;
            end
            B: begin
                next_state = B;

                if (cycle_cnt == 2) begin
                    // 3rd cycle completed: output is 1 if exactly 2 out of 3 w's are 1
                    next_z = (w_accum + w) == 2;

                    // reset counters for next 3-cycle window
                    next_cycle_cnt = 2'd0;
                    next_w_accum = 2'd0;
                end else begin
                    next_z = 1'b0;

                    // increment cycle count by 1
                    next_cycle_cnt = cycle_cnt + 1;

                    // accumulate w count by adding w (w is 1 bit, so add 1 if w=1 else 0)
                    next_w_accum = w_accum + w;
                end
            end
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_cnt <= 2'd0;
            w_accum <= 2'd0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            z <= next_z;

            // Update counters only when in state B to reduce toggling
            if (cnt_enable) begin
                cycle_cnt <= next_cycle_cnt;
                w_accum <= next_w_accum;
            end else begin
                cycle_cnt <= 2'd0;
                w_accum <= 2'd0;
            end
        end
    end

endmodule