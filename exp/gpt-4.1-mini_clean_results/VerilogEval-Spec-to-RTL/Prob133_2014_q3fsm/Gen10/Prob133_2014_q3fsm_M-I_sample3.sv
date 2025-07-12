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

    // Separate 2-bit registers for cycle count and w accumulator
    reg [1:0] cycle_cnt, next_cycle_cnt;
    reg [1:0] w_accum, next_w_accum;

    reg next_z;

    // Combinational logic for FSM next state, counters, and output
    always @(*) begin
        // Defaults
        next_state = state;
        next_cycle_cnt = cycle_cnt;
        next_w_accum = w_accum;
        next_z = z;  // Hold output by default

        case (state)
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
                // If last cycle of the 3-cycle window (0-based count: cycles 0,1,2)
                if (cycle_cnt == 2) begin
                    // Output z=1 if exactly two '1's in the 3-cycle w window (w_accum + w == 2)
                    next_z = ((w_accum + w) == 2);
                    // Reset counters for next window
                    next_cycle_cnt = 2'd0;
                    next_w_accum = 2'd0;
                end else begin
                    // Accumulate w and increment cycle count
                    next_cycle_cnt = cycle_cnt + 1'b1;
                    next_w_accum = w_accum + w;
                    next_z = 1'b0;
                end
            end

            default: begin
                next_state = A;
                next_z = 1'b0;
                next_cycle_cnt = 2'd0;
                next_w_accum = 2'd0;
            end
        endcase
    end

    // Sequential logic with synchronous active-high reset
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_cnt <= 2'd0;
            w_accum <= 2'd0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            z <= next_z;

            // Update counters only in state B to reduce switching
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