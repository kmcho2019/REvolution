module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    // States
    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state, next_state;

    // Cycle counter: counts 0 to 2 for 3 cycles in B
    reg [1:0] cycle_cnt, next_cycle_cnt;

    // w counter: counts how many times w=1 in current group of 3
    reg [1:0] w_count, next_w_count;

    // Output z registered one cycle after processing 3 w inputs
    reg z_next;

    // Next state and counters logic
    always @(*) begin
        // Defaults
        next_state = state;
        next_cycle_cnt = cycle_cnt;
        next_w_count = w_count;
        z_next = 1'b0;

        case(state)
            A: begin
                // Wait in A while s=0, move to B when s=1
                if (s) begin
                    next_state = B;
                    next_cycle_cnt = 2'd0;
                    next_w_count = 2'd0;
                end
            end
            B: begin
                // Count w if in B
                next_w_count = w_count + w;

                if (cycle_cnt == 2'd2) begin
                    // After the 3rd cycle (cycles 0,1,2), check count of w=1
                    // Assert z next cycle if exactly two w=1
                    // z_next is assigned in sequential block, combinational block sets counters

                    // Reset counters for next group of 3 cycles
                    next_cycle_cnt = 2'd0;
                    next_w_count = 2'd0;
                    // Stay in B state
                end else begin
                    // Increment cycle count to next cycle in group
                    next_cycle_cnt = cycle_cnt + 1'b1;
                end
            end
            default: begin
                next_state = A;
                next_cycle_cnt = 2'd0;
                next_w_count = 2'd0;
            end
        endcase
    end

    // Sequential logic: registers update on posedge clk
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

            // Output z asserted only one cycle after completing 3 w inputs
            if (state == B && cycle_cnt == 2'd2) begin
                // We have finished counting 3 cycles of w, w_count now includes all three
                // Wait for next cycle to assert z, so assert here z from previous counts
                // Because counters reset in combinational block already,
                // so use w_count before update (registered value) plus current w to check count

                // Count of w=1 in current group is w_count (which includes previous cycles) + current w
                // But w_count was updated already before assignment, so we can use next_w_count here,
                // which is w_count + w as combinational. However, registers update now,
                // so w_count still holds count of previous cycles only.

                // Therefore, to determine if exactly two w=1, sum w_count and w:
                if ((w_count + w) == 2) begin
                    z <= 1'b1;
                end else begin
                    z <= 1'b0;
                end
            end else begin
                z <= 1'b0;
            end
        end
    end

endmodule