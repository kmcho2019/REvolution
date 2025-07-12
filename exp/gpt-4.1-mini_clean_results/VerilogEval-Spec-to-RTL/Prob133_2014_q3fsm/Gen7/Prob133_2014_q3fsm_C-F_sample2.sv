module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    // State encoding: 1-bit state, two states A and B
    localparam A = 1'b0, B = 1'b1;

    reg state, next_state;

    reg [1:0] cycle_cnt, next_cycle_cnt;  // counts 0..2 cycles of w in B
    reg [1:0] w_accum, next_w_accum;      // counts number of times w=1 in current window
    reg z_next;

    // Combinational next state logic and outputs
    always @(*) begin
        // Defaults
        next_state = state;
        next_cycle_cnt = cycle_cnt;
        next_w_accum = w_accum;
        z_next = 1'b0;

        case(state)
            A: begin
                // Wait for s=1 to enter B, output zero and counters cleared in sequential logic
                if (s)
                    next_state = B;
                else
                    next_state = A;
                // Keep counters zero in combinational, but actual reset is synchronous in sequential block
                next_cycle_cnt = 2'd0;
                next_w_accum = 2'd0;
                z_next = 1'b0;
            end

            B: begin
                // Accumulate w count for current window
                next_w_accum = w_accum + w;

                if (cycle_cnt == 2) begin
                    // End of 3-cycle window: output depends on accumulator + current w
                    // Because w has been added in next_w_accum, check if equal to 2
                    if (next_w_accum == 2)
                        z_next = 1'b1;
                    else
                        z_next = 1'b0;

                    next_cycle_cnt = 2'd0;       // reset counter for next window
                    next_w_accum = 2'd0;         // reset accumulator for next window
                    next_state = B;              // remain in B
                end else begin
                    // Continue counting cycles in window
                    next_cycle_cnt = cycle_cnt + 1;
                    z_next = 1'b0;
                    next_state = B;
                end
            end

            default: begin
                // Defensive fallback
                next_state = A;
                next_cycle_cnt = 2'd0;
                next_w_accum = 2'd0;
                z_next = 1'b0;
            end
        endcase
    end

    // Sequential state, counters and output update
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

endmodule