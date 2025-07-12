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

    // Combinational logic for next-state, counters, output
    always @(*) begin
        // Default assignments to hold current values
        next_state = state;
        next_cycle_cnt = cycle_cnt;
        next_w_accum = w_accum;
        next_z = z;

        case (state)
            A: begin
                // Reset counters and output when in state A
                next_cycle_cnt = 2'd0;
                next_w_accum = 2'd0;
                next_z = 1'b0;
                if (s)
                    next_state = B;
                else
                    next_state = A;
            end

            B: begin
                next_state = B;
                next_z = 1'b0; // default output low unless end of 3-cycle window

                if (cycle_cnt == 2) begin
                    // Last cycle of 3-cycle window; include current w
                    // sum = w_accum + w (possible values 0..3)
                    // z = 1 if sum == 2 else 0
                    next_z = ((w_accum + w) == 2);

                    // Reset counters for next window
                    next_cycle_cnt = 2'd0;
                    next_w_accum = 2'd0;
                end else begin
                    // Accumulate cycle count and w count
                    next_cycle_cnt = cycle_cnt + 2'd1;
                    next_w_accum = w_accum + w;
                    next_z = 1'b0;
                end
            end

            default: begin
                next_state = A;
                next_cycle_cnt = 2'd0;
                next_w_accum = 2'd0;
                next_z = 1'b0;
            end
        endcase
    end

    // Sequential logic: state, counters, output register update
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_cnt <= 2'd0;
            w_accum <= 2'd0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            z <= next_z;

            // Update counters only in state B to reduce toggling
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