module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    // State encoding
    typedef enum reg [0:0] {
        A = 1'b0,
        B = 1'b1
    } state_t;

    reg state, next_state;

    reg [1:0] w_count; // Counts how many w=1 in current 3-cycle window (max 3)
    reg [1:0] cycle_count; // Counts cycles in B (0 to 2)

    // Sequential block: state transitions, counters and output
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            w_count <= 2'd0;
            cycle_count <= 2'd0;
            z <= 1'b0;
        end else begin
            state <= next_state;

            if (state == A) begin
                // In state A no counters used, z=0
                z <= 1'b0;
                w_count <= 2'd0;
                cycle_count <= 2'd0;
            end else begin
                // In state B: count w and cycles
                // Increment cycle_count
                if (cycle_count < 2)
                    cycle_count <= cycle_count + 1;
                else
                    cycle_count <= 0;

                // Count w if it is 1
                if (w)
                    w_count <= w_count + 1;
                else
                    w_count <= w_count;

                // When cycle_count resets to zero, meaning 3 cycles done (0,1,2),
                // evaluate w_count (which accumulated number of w=1's in those 3 cycles).
                // Output z=1 if w_count == 2; else 0
                if (cycle_count == 2) begin
                    // end of 3rd cycle - output z next cycle, i.e. on next posedge clk
                    // So set z here, after counting current cycle's w and cycle_count updated
                    // But we have updated counters at start of posedge clock, so z should be set on next cycle
                    // To produce z at following cycle, we can store z in next cycle registers.
                    // To keep logic simple, we output z for one cycle immediately when cycle_count == 2
                    // So output z=1 now if w_count == 2 + current w
                    // Since w_count was incremented with current w, we use w_count

                    if (w_count == 2)
                        z <= 1'b1;
                    else
                        z <= 1'b0;

                    // Reset w_count for next 3-cycle window in next cycle
                    w_count <= 2'd0;
                end else begin
                    z <= 1'b0;
                end
            end
        end
    end

    // Next state logic combinational
    always @(*) begin
        case(state)
            A: begin
                if (s == 1'b1)
                    next_state = B;
                else
                    next_state = A;
            end
            B: begin
                next_state = B; // Remain in B always
            end
            default: next_state = A;
        endcase
    end

endmodule