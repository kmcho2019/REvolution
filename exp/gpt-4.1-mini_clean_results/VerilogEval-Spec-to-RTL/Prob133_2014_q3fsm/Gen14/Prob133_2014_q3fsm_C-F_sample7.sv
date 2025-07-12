module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    // State encoding
    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state, next_state;
    reg [1:0] cycle_cnt, next_cycle_cnt; // counts cycles in groups of 3: 0..2
    reg [1:0] w_accum, next_w_accum;     // counts number of w=1 in current group of 3 cycles

    reg z_next;

    // Combinational logic: next state, counters, and output logic
    always @(*) begin
        // Defaults: remain in current state and counters; z defaults 0 to minimize toggling
        next_state = state;
        next_cycle_cnt = cycle_cnt;
        next_w_accum = w_accum;
        z_next = 1'b0;

        case(state)
            A: begin
                // In state A, counters reset and output zero
                next_cycle_cnt = 2'b00;
                next_w_accum = 2'b00;
                z_next = 1'b0;
                if (s)
                    next_state = B;
            end

            B: begin
                if (cycle_cnt == 2) begin
                    // On the third cycle, evaluate total count (w_accum + current w)
                    if ((w_accum + w) == 2)
                        z_next = 1'b1;
                    else
                        z_next = 1'b0;

                    // Prepare counters for next group of 3 cycles
                    next_cycle_cnt = 2'b00;
                    next_w_accum = 2'b00;
                    // Remain in B
                    next_state = B;
                end else begin
                    // Accumulate current w into w_accum and increment cycle counter
                    next_cycle_cnt = cycle_cnt + 1'b1;
                    next_w_accum = w_accum + w;
                    z_next = 1'b0;
                end
            end

            default: begin
                // Safe fallback: reset to A
                next_state = A;
                next_cycle_cnt = 2'b00;
                next_w_accum = 2'b00;
                z_next = 1'b0;
            end
        endcase
    end

    // Sequential logic: update registers on posedge clk, synchronous reset
    // Only update counters when in state B to reduce toggling (clock enable style)
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_cnt <= 2'b00;
            w_accum <= 2'b00;
            z <= 1'b0;
        end else begin
            state <= next_state;
            z <= z_next;
            if (next_state == B) begin
                cycle_cnt <= next_cycle_cnt;
                w_accum <= next_w_accum;
            end else begin
                cycle_cnt <= 2'b00;
                w_accum <= 2'b00;
            end
        end
    end

endmodule