module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    typedef enum logic [2:0] {
        A   = 3'd0,  // waiting for s=1
        B0  = 3'd1,  // first cycle after entering B, count=0 w=1's so far
        B1  = 3'd2,  // second cycle after B0, counted 1 w=1 so far
        B2  = 3'd3,  // second cycle after B0, counted 0 w=1 so far
        B3  = 3'd4   // third cycle, count determined by previous and current w
    } state_t;

    state_t state, next_state;
    reg z_next;

    always @(*) begin
        // Defaults
        next_state = state;
        z_next = 1'b0;

        case (state)
            A: begin
                z_next = 1'b0;
                if (s)
                    next_state = B0;
                else
                    next_state = A;
            end

            B0: begin
                // First cycle: record w in state for next cycle
                // if w=1 go to B1, else B2
                z_next = 1'b0;
                next_state = w ? B1 : B2;
            end

            B1: begin
                // Second cycle, already counted 1 w=1 so far
                // if w=1 then 2 w=1's so far (go to B3 with count=2)
                // else still only 1 w=1 so far (go to B3 with count=1)
                z_next = 1'b0;
                next_state = w ? B3 : B3;
            end

            B2: begin
                // Second cycle, counted 0 w=1 so far
                // if w=1 then 1 w=1 so far (go to B3 with count=1)
                // else still 0 w=1 so far (go to B3 with count=0)
                z_next = 1'b0;
                next_state = B3;
            end

            B3: begin
                // Third cycle: count is encoded by previous state and current w
                // Based on current state and w, output z=1 if total count of w=1 is exactly 2
                // After outputting z, restart counting cycles at B0
                // We'll decode count inside sequential block to assert z next cycle

                // z_next assigned in sequential block for timing correctness

                next_state = B0; // Restart counting 3-cycle window
                z_next = 1'b0;   // z updated in sequential block
            end

            default: begin
                next_state = A;
                z_next = 1'b0;
            end
        endcase
    end

    // Internal signal to hold if exactly two w=1's were counted in last 3 cycles
    reg z_int;

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            z <= 1'b0;
            z_int <= 1'b0;
        end else begin
            state <= next_state;

            // Compute and register output z only in B3 state,
            // based on previous state and current input w

            // If currently in B3, previous state is one of B0, B1, B2
            // Because next_state of B0/B1/B2 is B3
            // We'll store previous state in state reg to know counts

            if (state == B3) begin
                // Determine total count of w=1 over the 3 cycles:

                // The count depends on how we reached B3:
                // From B1: second cycle had 1 or 2 w=1's before current w
                // From B2: second cycle had 0 or 1 w=1's before current w
                // But since the FSM doesn't have prior info here,
                // we must reconstruct count based on state and input history
                // To solve this, let's extend encoding in state transitions:

                // To know the total count over the 3 cycles, we can track partial count using state variable
                // Because we can't look back, instead, store count in a small register updated in B0,B1,B2

                // Let's add a small reg to hold count of w=1 after two cycles to compute with w input on B3

                // This requires a slight redesign: add w_count reg updated on B0,B1,B2

                // Move this logic to sequential block below

                z <= z_int; // output previous cycle's decision
            end else begin
                z <= 1'b0;
            end
        end
    end

    // We now add a small register to hold w count accumulated in first two cycles of B states

    reg [1:0] w_count;   // holds count of w=1 in first two cycles of B states
    reg update_wcount;

    always @(posedge clk) begin
        if (reset) begin
            w_count <= 2'd0;
            z_int <= 1'b0;
            update_wcount <= 1'b0;
        end else begin
            // Default
            update_wcount <= 1'b0;
            z_int <= 1'b0;

            case (next_state)
                B0: begin
                    // Starting new window, reset count
                    w_count <= 2'd0;
                end

                B1: begin
                    // w=1 counted once on B0, so count=1
                    // w input on B0 determined transition to B1
                    // So on transition to B1, w_count = 1
                    w_count <= 2'd1;
                end

                B2: begin
                    // w=0 counted on B0, w_count=0
                    w_count <= 2'd0;
                end

                B3: begin
                    // Now we know count for first two cycles in w_count
                    // Add current w to w_count to get total for 3 cycles
                    // Output z=1 if total count == 2

                    if ((w_count + w) == 2)
                        z_int <= 1'b1;
                    else
                        z_int <= 1'b0;

                    update_wcount <= 1'b1; // no use here but keep consistent
                end

                default: begin
                    // No changes
                end
            endcase
        end
    end

endmodule