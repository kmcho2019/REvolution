module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    // State encoding
    typedef enum logic [0:0] {A=1'b0, B=1'b1} state_t;
    state_t state, next_state;

    reg [1:0] cycle_cnt, next_cycle_cnt;  // 0..2 counting cycles in B
    reg [1:0] w_count, next_w_count;      // count w=1 occurrences in 3-cycle window

    always @(*) begin
        // Default next values
        next_state = state;
        next_cycle_cnt = cycle_cnt;
        next_w_count = w_count;
        // Default output is 0; z updated only after full window
        // Output z is registered in sequential block, so here for next state logic
        // We do not drive z here, only update counters and state.

        case (state)
            A: begin
                // Reset counters and z in state A
                next_cycle_cnt = 2'd0;
                next_w_count = 2'd0;
                if (s)
                    next_state = B;
                else
                    next_state = A;
            end

            B: begin
                // Accumulate w counts and increment cycle count
                next_w_count = w_count + w;
                if (cycle_cnt == 2) begin
                    // End of 3-cycle window, prepare for next window
                    next_cycle_cnt = 2'd0;
                    next_w_count = 2'd0;
                    next_state = B;
                end else begin
                    next_cycle_cnt = cycle_cnt + 1;
                    next_state = B;
                end
            end

            default: begin
                next_state = A;
                next_cycle_cnt = 2'd0;
                next_w_count = 2'd0;
            end
        endcase
    end

    // Sequential update block, synchronous reset, posedge clock
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_cnt <= 2'd0;
            w_count <= 2'd0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            cycle_cnt <= next_cycle_cnt;
            w_count <= next_w_count;

            // Update output z only after completing the 3-cycle window in state B
            // The output z is set on the cycle AFTER counting the third w input
            // That means when cycle_cnt == 2 before update, output is valid next cycle
            if (state == B && cycle_cnt == 2) begin
                // Check if the total count of w=1 is exactly 2 in this 3-cycle window
                // total_w = w_count + current w (already added in next_w_count)
                // But since next_w_count resets to 0 after this cycle, use w_count + w here
                if ((w_count + w) == 2)
                    z <= 1'b1;
                else
                    z <= 1'b0;
            end else if (state == A) begin
                z <= 1'b0; // output zero in state A
            end else begin
                z <= 1'b0; // zero output on other cycles in B
            end
        end
    end

endmodule