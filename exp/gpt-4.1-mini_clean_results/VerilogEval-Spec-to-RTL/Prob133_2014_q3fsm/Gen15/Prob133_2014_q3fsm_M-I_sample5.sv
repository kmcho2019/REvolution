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

    reg [1:0] cycle_cnt, next_cycle_cnt;  // counts 0..2 for 3 cycles
    reg [1:0] w_accum, next_w_accum;      // counts number of w=1 in window (max 3)

    reg z_next;

    always @(*) begin
        // Defaults
        next_state = state;
        next_cycle_cnt = cycle_cnt;
        next_w_accum = w_accum;
        z_next = 1'b0;

        case (state)
            A: begin
                z_next = 1'b0;
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
                    // 3rd cycle of window reached, decide output next cycle
                    // Total count is w_accum + current w (w=1 increments count)
                    z_next = ((w_accum + w) == 2);

                    // reset counters for next window
                    next_cycle_cnt = 2'd0;
                    next_w_accum = 2'd0;
                end else begin
                    z_next = 1'b0;
                    next_cycle_cnt = cycle_cnt + 2'd1;
                    // increment w_accum only if w==1
                    next_w_accum = w_accum + (w ? 2'd1 : 2'd0);
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
            z <= z_next;

            // Update counters only in state B to reduce toggling in A
            if (next_state == B) begin
                cycle_cnt <= next_cycle_cnt;
                w_accum <= next_w_accum;
            end else begin
                cycle_cnt <= 2'd0;
                w_accum <= 2'd0;
            end
        end
    end

endmodule