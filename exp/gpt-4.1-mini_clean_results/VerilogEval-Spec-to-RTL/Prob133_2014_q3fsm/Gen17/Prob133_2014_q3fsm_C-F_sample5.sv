module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    // State encoding using single bit for compactness
    localparam A = 1'b0, B = 1'b1;
    reg state, next_state;

    reg [1:0] cycle_cnt, next_cycle_cnt;
    reg [1:0] w_sum, next_w_sum;

    // Combinational logic for next state, counters and output decision
    always @* begin
        // Defaults hold current values to prevent latches
        next_state = state;
        next_cycle_cnt = cycle_cnt;
        next_w_sum = w_sum;
        // z is registered, so here only tracking if z will be set next cycle
        // Assign 0 here by default, set to 1 only at cycle == 2 in state B if condition met
        // z reg updated in sequential block
        // We'll output z one cycle after counting 3 cycles, matching spec
        // Therefore, set an internal signal z_set to use in seq block
        // But here, only combinational logic for next state/counters; z assigned in seq.
    end

    reg z_set; // internal signal to latch in sequential block for z output

    always @* begin
        // Overwrite defaults
        z_set = 1'b0; 

        case(state)
            A: begin
                // Remain in A as long as s=0, move to B when s=1
                if (s)
                    next_state = B;
                else
                    next_state = A;

                // Clear counters in A to avoid toggling in B
                next_cycle_cnt = 2'd0;
                next_w_sum = 2'd0;
            end

            B: begin
                // Accumulate w and count cycles only in B
                next_w_sum = w_sum + w;

                if (cycle_cnt == 2) begin
                    // After third cycle, check if exactly two w=1 were counted
                    // Output z is asserted next cycle (z_set here for next cycle)
                    z_set = ((w_sum + w) == 2);

                    // Reset counters for next 3 cycle window
                    next_cycle_cnt = 2'd0;
                    next_w_sum = 2'd0;
                end else begin
                    next_cycle_cnt = cycle_cnt + 2'd1;
                end

                // Stay in state B continuously
                next_state = B;
            end

            default: begin
                // Defensive fallback to reset FSM if invalid state
                next_state = A;
                next_cycle_cnt = 2'd0;
                next_w_sum = 2'd0;
                z_set = 1'b0;
            end
        endcase
    end

    // Sequential logic block: update state, counters, and output z
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_cnt <= 2'd0;
            w_sum <= 2'd0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            cycle_cnt <= next_cycle_cnt;
            w_sum <= next_w_sum;
            z <= z_set;
        end
    end

endmodule