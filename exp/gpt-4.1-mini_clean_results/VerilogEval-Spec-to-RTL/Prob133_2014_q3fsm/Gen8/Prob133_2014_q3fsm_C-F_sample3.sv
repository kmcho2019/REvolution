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

    reg [1:0] cycle_cnt, next_cycle_cnt;    // counts cycles in the 3-cycle window: 0..2
    reg [1:0] w_accum, next_w_accum;        // counts number of w=1 in current window
    reg z_next;

    // Sequential block: state, counters, output
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_cnt <= 2'd0;
            w_accum <= 2'd0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            cycle_cnt <= next_cycle_cnt;
            w_accum <= next_w_accum;
            z <= z_next;
        end
    end

    // Combinational block: next state, counters, and output logic
    always @(*) begin
        // Default assignments to avoid latches and unnecessary toggling
        next_state = state;
        next_cycle_cnt = cycle_cnt;
        next_w_accum = w_accum;
        z_next = z;  // hold output stable by default

        case (state)
            A: begin
                // Reset counters and output in state A
                next_cycle_cnt = 2'd0;
                next_w_accum = 2'd0;
                z_next = 1'b0;

                if (s)
                    next_state = B;
                else
                    next_state = A;
            end

            B: begin
                if (cycle_cnt == 2) begin
                    // End of 3-cycle window; include current w in accumulation
                    // Evaluate output for next cycle
                    if (w_accum + w == 2)
                        z_next = 1'b1;
                    else
                        z_next = 1'b0;

                    // Reset counters for next window
                    next_cycle_cnt = 2'd0;
                    next_w_accum = 2'd0;
                    next_state = B; // remain in B
                end else begin
                    // Counting cycles and accumulating w=1 count
                    next_cycle_cnt = cycle_cnt + 1'b1;
                    next_w_accum = w_accum + w;
                    z_next = 1'b0;  // output zero except after window ends
                    next_state = B;
                end
            end

            default: begin
                // Safety defaults in case of unexpected state
                next_state = A;
                next_cycle_cnt = 2'd0;
                next_w_accum = 2'd0;
                z_next = 1'b0;
            end
        endcase
    end

endmodule