module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    // State encoding: 2 bits for 4 states
    localparam A   = 2'd0; // Waiting for s=1
    localparam B_0 = 2'd1; // 1st cycle in counting window
    localparam B_1 = 2'd2; // 2nd cycle in counting window
    localparam B_2 = 2'd3; // 3rd cycle in counting window

    reg [1:0] state, next_state;
    reg [1:0] w_count;      // count of w=1 in current 3-cycle window
    reg z_next;

    // Next state and output logic combinational block
    always @(*) begin
        // Default assignments
        next_state = state;
        z_next = 1'b0;

        case(state)
            A: begin
                if (s)
                    next_state = B_0;
                else
                    next_state = A;
            end

            B_0: next_state = B_1;

            B_1: next_state = B_2;

            B_2: next_state = B_0; // After 3rd cycle, restart counting window

            default: next_state = A;
        endcase

        // Output z logic: asserted for one cycle right after counting 3 w inputs
        if (state == B_2) begin
            // After sampling third w, decide output in next cycle (B_0)
            // But output must be registered and valid one cycle later.
            // So we assert z_next = 1 if w_count + current w == 2
            // Because we add w count for this cycle here in sequential block,
            // here w_count is sum of previous two cycles, so need to add current w.

            if ((w_count + w) == 2)
                z_next = 1'b1;
            else
                z_next = 1'b0;
        end else begin
            z_next = 1'b0;
        end
    end

    // Sequential logic: state and counters update on posedge clk
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            w_count <= 2'd0;
            z <= 1'b0;
        end else begin
            state <= next_state;

            case(state)
                A: begin
                    w_count <= 2'd0;
                    z <= 1'b0;
                end

                B_0, B_1: begin
                    // Accumulate w counts for first two cycles
                    w_count <= w_count + w;
                    z <= 1'b0;
                end

                B_2: begin
                    // On third cycle, finalize w_count by adding w for this cycle,
                    // then output z_next (computed combinationally) in the next cycle.
                    // We delay z update to next cycle when state goes to B_0,
                    // so here just accumulate count and clear later.

                    // However, to output z exactly one cycle after the 3rd sample,
                    // we update output in state B_0 (the next state).
                    w_count <= 2'd0; 
                    z <= z_next;
                end

                default: begin
                    w_count <= 2'd0;
                    z <= 1'b0;
                end
            endcase
        end
    end

endmodule