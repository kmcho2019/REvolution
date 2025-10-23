module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    // State encoding: minimal 1-bit state
    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state, next_state;

    // 2-bit cycle counter for counting 3 cycles (0 to 2)
    reg [1:0] cycle_cnt, next_cycle_cnt;

    // 2-bit w accumulator counting number of w=1 in current 3-cycle window (max 3)
    reg [1:0] w_accum, next_w_accum;

    // Next cycle output of z
    reg next_z;

    // Clock enable for counters: enabled only in state B
    wire cnt_enable = (state == B);

    always @(*) begin
        // Default assignments to maintain previous values unless changed
        next_state = state;
        next_cycle_cnt = cycle_cnt;
        next_w_accum = w_accum;
        next_z = 1'b0;

        case (state)
            A: begin
                // Remain in A unless s=1
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
                    // End of 3-cycle window: check if exactly two w=1 in window (w_accum + current w)
                    next_z = ((w_accum + w) == 2);

                    // Reset counters for next window
                    next_cycle_cnt = 2'd0;
                    next_w_accum = 2'd0;
                end else begin
                    next_z = 1'b0;

                    // Increment cycle count by 1
                    next_cycle_cnt = cycle_cnt + 1;

                    // Accumulate w count by adding current w (w is 1-bit, so adds 0 or 1)
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

            // Update counters only when in state B to minimize toggling
            if (cnt_enable) begin
                cycle_cnt <= next_cycle_cnt;
                w_accum <= next_w_accum;
            end else begin
                // Hold counters at zero in other states to reduce toggling
                cycle_cnt <= 2'd0;
                w_accum <= 2'd0;
            end
        end
    end

endmodule