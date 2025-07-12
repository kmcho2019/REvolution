module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output reg z
);

    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state, next_state;
    reg [1:0] cycle_cnt, next_cycle_cnt;   // counts 0..2 cycles in B
    reg [1:0] w_accum, next_w_accum;       // accumulates number of w=1 in window

    reg next_z;

    always @(*) begin
        // Defaults
        next_state = state;
        next_cycle_cnt = cycle_cnt;
        next_w_accum = w_accum;
        next_z = 1'b0;

        case(state)
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
                // Accumulate w count and increment cycle counter
                next_w_accum = w_accum + w;
                if (cycle_cnt == 2) begin
                    // At 3rd cycle of window, decide z for next cycle
                    if (w_accum + w == 2)
                        next_z = 1'b1;
                    else
                        next_z = 1'b0;

                    next_cycle_cnt = 2'd0;     // reset cycle count for new window
                    next_w_accum = 2'd0;       // reset w accumulator for new window
                end else begin
                    next_cycle_cnt = cycle_cnt + 1;
                    next_z = 1'b0;
                end
                next_state = B;
            end
        endcase
    end

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
            z <= next_z;
        end
    end

endmodule