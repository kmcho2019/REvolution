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

    reg [1:0] cycle_cnt, next_cycle_cnt; // counts from 0 to 2 for the 3-cycle window
    reg [1:0] w_accum, next_w_accum;     // counts number of w=1 in current window

    reg next_z;

    // Update combinational logic for next state and counters
    always @(*) begin
        // Default assignments
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
                next_state = B;
                // Check if current cycle is the last in the 3-cycle window
                if (cycle_cnt == 2) begin
                    // At the end of window: output z = 1 if w_accum + current w == 2
                    if ( (w_accum + w) == 2 )
                        next_z = 1'b1;
                    else
                        next_z = 1'b0;

                    // Reset counters for next window
                    next_cycle_cnt = 2'd0;
                    next_w_accum = 2'd0;
                end else begin
                    // Middle cycles in the window: increment counters
                    next_cycle_cnt = cycle_cnt + 2'd1;

                    // Add w to w_accum without adder: increment by 1 if w=1, else same
                    if (w)
                        next_w_accum = w_accum + 2'd1;
                    else
                        next_w_accum = w_accum;

                    next_z = 1'b0;
                end
            end
        endcase
    end

    // Sequential block: update state, counters, and output with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle_cnt <= 2'd0;
            w_accum <= 2'd0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            z <= next_z;

            // Update counters only in state B, zero otherwise to reduce toggling
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